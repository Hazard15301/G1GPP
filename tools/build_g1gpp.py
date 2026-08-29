#!/usr/bin/env python3
"""One-command G1GPP validation and deterministic development packaging."""

from pathlib import Path, PurePosixPath
import argparse
import hashlib
import json
import os
import subprocess
import sys
import tempfile
import time
import zipfile

ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "g1gpp"
CONFIG = ROOT / "tools" / "build_toolchain.json"
BANNED = {".png", ".jpg", ".jpeg", ".gif", ".bmp", ".wav", ".mp3",
          ".ogg", ".flac", ".gb", ".gbc", ".rom", ".sav", ".state",
          ".bin", ".raw", ".dmp"}
ZIP_TIME = (2026, 8, 22, 0, 0, 0)


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest().upper()


def run(label, command, env):
    print(f"\n== {label} ==", flush=True)
    proc = subprocess.run(command, cwd=ROOT, env=env)
    if proc.returncode:
        raise SystemExit(f"FAIL: {label} exited {proc.returncode}")


def run_quiet(label, command, env):
    print(f"\n== {label} ==", flush=True)
    proc = subprocess.run(command, cwd=ROOT, env=env,
                          capture_output=True, text=True)
    if proc.returncode:
        print(proc.stdout, end="")
        print(proc.stderr, end="", file=sys.stderr)
        raise SystemExit(f"FAIL: {label} exited {proc.returncode}")
    print(f"PASS: {label}")


def findings_fingerprint(findings):
    lines = sorted(
        f"{item.get('rule', '')}|{item.get('path') or ''}|{item.get('message', '')}"
        for item in findings
    )
    return hashlib.sha256("\n".join(lines).encode("utf-8")).hexdigest().upper()


def run_modkit_json(label, command, env, expected):
    print(f"\n== {label} ==", flush=True)
    proc = subprocess.run(command + ["--json"], cwd=ROOT, env=env,
                          capture_output=True, text=True)
    if proc.returncode:
        print(proc.stdout, end="")
        print(proc.stderr, end="", file=sys.stderr)
        raise SystemExit(f"FAIL: {label} exited {proc.returncode}")
    try:
        result = json.loads(proc.stdout)
    except json.JSONDecodeError:
        print(proc.stdout, end="")
        raise SystemExit(f"FAIL: {label} returned invalid JSON")
    findings = result.get("findings", [])
    fingerprint = findings_fingerprint(findings)
    if len(findings) != expected["count"] or fingerprint != expected["sha256"]:
        print(json.dumps(findings, indent=2))
        raise SystemExit(
            f"FAIL: {label} findings changed: count={len(findings)} sha256={fingerprint}")
    if not result.get("ok"):
        raise SystemExit(f"FAIL: {label} reported errors")
    print(f"PASS: {label}; {len(findings)} reviewed baseline warnings unchanged")


def verify_toolchain(config):
    luajit = Path(os.environ.get("G1GPP_LUAJIT", config["luajit"]["path"]))
    modkit = Path(os.environ.get("G1GPP_MODKIT", config["modkit"]["path"]))
    data = Path(os.environ.get("POKEPORT_DATA_DIR", config["player_cache"]["data"]))
    assets = Path(os.environ.get("POKEPORT_ASSET_DIR", config["player_cache"]["assets"]))
    gold = Path(os.environ.get("POKEPORT_GOLD_ROOT", config["player_cache"]["gold"]))
    for label, path in (("LuaJIT", luajit), ("modkit", modkit),
                        ("player data cache", data), ("player asset cache", assets),
                        ("player Gold cache", gold)):
        if not path.exists():
            raise SystemExit(f"FAIL: {label} missing: {path}")
    expected = config["luajit"]["sha256"].upper()
    actual = sha256(luajit)
    if actual != expected:
        raise SystemExit(f"FAIL: LuaJIT hash mismatch: {actual}")
    dll = luajit.with_name("lua51.dll")
    if not dll.is_file() or sha256(dll) != config["luajit"]["dll_sha256"].upper():
        raise SystemExit("FAIL: pinned LuaJIT lua51.dll is missing or changed")
    modkit_repo = modkit.parents[1]
    commit = subprocess.run(["git", "-C", str(modkit_repo), "rev-parse", "HEAD"],
                            capture_output=True, text=True, check=True).stdout.strip()
    if commit != config["modkit"]["commit"]:
        raise SystemExit(f"FAIL: pinned modkit commit changed: {commit}")
    status = subprocess.run(["git", "-C", str(modkit_repo), "status", "--porcelain"],
                            capture_output=True, text=True, check=True).stdout.strip()
    if status:
        raise SystemExit("FAIL: public Gen1Recomp validator checkout has local modifications")
    expected_modkit = config["modkit"]["sha256"].upper()
    actual_modkit = sha256(modkit)
    if actual_modkit != expected_modkit:
        raise SystemExit(f"FAIL: modkit hash mismatch: {actual_modkit}")
    return luajit, modkit, data, assets, gold


def source_files():
    return sorted(path for path in MOD.rglob("*") if path.is_file())


def package(output, files):
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=output.parent, suffix=".zip",
                                     delete=False) as handle:
        temporary = Path(handle.name)
    try:
        with zipfile.ZipFile(temporary, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
            for path in files:
                relative = path.relative_to(MOD).as_posix()
                info = zipfile.ZipInfo(f"g1gpp/{relative}", ZIP_TIME)
                info.compress_type = zipfile.ZIP_DEFLATED
                info.external_attr = 0o100644 << 16
                archive.writestr(info, path.read_bytes(), compresslevel=9)
    except BaseException:
        temporary.unlink(missing_ok=True)
        raise
    return temporary


def verify_package(output, files):
    expected = {p.relative_to(MOD).as_posix(): sha256(p) for p in files}
    with zipfile.ZipFile(output) as archive:
        records = [info for info in archive.infolist() if not info.is_dir()]
        actual = {}
        banned = []
        for info in records:
            name = info.filename.replace("\\", "/")
            if not name.startswith("g1gpp/"):
                raise SystemExit(f"FAIL: ZIP entry outside g1gpp/: {name}")
            relative = name[len("g1gpp/"):]
            actual[relative] = hashlib.sha256(archive.read(info)).hexdigest().upper()
            if PurePosixPath(name).suffix.lower() in BANNED:
                banned.append(name)
    if expected != actual:
        raise SystemExit("FAIL: packaged files do not exactly match source")
    if banned:
        raise SystemExit("FAIL: prohibited binary entries: " + ", ".join(banned))
    return len(actual)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", type=Path, default=Path.home() / "Downloads")
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--replace", action="store_true",
                        help="atomically replace an existing ZIP after the new one verifies")
    args = parser.parse_args()
    started = time.monotonic()
    config = json.loads(CONFIG.read_text(encoding="utf-8"))
    manifest = json.loads((MOD / "manifest.json").read_text(encoding="utf-8"))
    luajit, modkit, data, assets, gold = verify_toolchain(config)

    env = os.environ.copy()
    env.update({
        "MODKIT_LUAJIT": str(luajit),
        "LUA": str(luajit),
        "G1GPP_MODKIT": str(modkit),
        "POKEPORT_DATA_DIR": str(data),
        "POKEPORT_ASSET_DIR": str(assets),
        "POKEPORT_GOLD_ROOT": str(gold),
    })
    run("G1GPP source preflight", [sys.executable, str(ROOT / "tools" / "check_lua_structure.py")], env)
    for test in sorted((ROOT / "tools" / "tests").glob("*_spec.lua")):
        run(f"Lua behavior: {test.stem}", [str(luajit), str(test), str(ROOT)], env)
    run_modkit_json("Gen1Recomp headless loader", [sys.executable,
        str(ROOT / "tools" / "g1gpp_modkit_adapter.py"),
        "validate", str(MOD), "--base", "imported"], env,
        config["expected_findings"]["loader"])
    run_modkit_json("Gen1Recomp captured-content lint",
        [sys.executable, str(modkit), "lint", str(MOD)], env,
        config["expected_findings"]["lint"])
    run_quiet("Git whitespace check", ["git", "diff", "--check"], env)

    if args.check_only:
        print(f"\nPASS: all checks in {time.monotonic() - started:.2f}s")
        return 0

    output = args.output_dir / f"G1GPP_v{manifest['version']}.zip"
    if output.exists() and not args.replace:
        raise SystemExit(f"FAIL: output already exists: {output}")
    files = source_files()
    temporary = package(output, files)
    try:
        count = verify_package(temporary, files)
        temporary.replace(output)
    except BaseException:
        temporary.unlink(missing_ok=True)
        raise
    print(f"\nPASS: {count} files packaged in {time.monotonic() - started:.2f}s")
    print(f"ZIP: {output}")
    print(f"SHA-256: {sha256(output)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
