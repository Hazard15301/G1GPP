#!/usr/bin/env python3
"""Build and verify the debug-free, root-layout G1GPP public release."""

from pathlib import Path, PurePosixPath
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
import zipfile

import build_g1gpp as common

ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "g1gpp"
CONFIG = ROOT / "tools" / "build_toolchain.json"
ZIP_TIME = (2026, 8, 29, 0, 0, 0)

PUBLIC_EXCLUDES = {
    "DEVELOPMENT_BUILD_NOTICE.txt",
    "data/encounters.lua",
    "modules/debug_battle_escape.lua",
    "modules/debug_inventory_tools.lua",
    "modules/debug_menu_groups.lua",
    "modules/debug_surf_access.lua",
    "modules/glitch_pokedex_viewer.lua",
}


def public_source_files():
    files = []
    for path in MOD.rglob("*"):
        if not path.is_file():
            continue
        relative = path.relative_to(MOD).as_posix()
        if relative.startswith("developer_tools/") or relative in PUBLIC_EXCLUDES:
            continue
        files.append(path)
    return sorted(files)


def stage_public_mod(stage):
    for source in public_source_files():
        relative = source.relative_to(MOD)
        destination = stage / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
    shutil.copy2(ROOT / "LICENSE", stage / "LICENSE")


def package(stage, output):
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=output.parent, suffix=".zip",
                                     delete=False) as handle:
        temporary = Path(handle.name)
    try:
        with zipfile.ZipFile(temporary, "w", zipfile.ZIP_DEFLATED,
                             compresslevel=9) as archive:
            for path in sorted(p for p in stage.rglob("*") if p.is_file()):
                relative = path.relative_to(stage).as_posix()
                info = zipfile.ZipInfo(relative, ZIP_TIME)
                info.compress_type = zipfile.ZIP_DEFLATED
                info.external_attr = 0o100644 << 16
                archive.writestr(info, path.read_bytes(), compresslevel=9)
        return temporary
    except BaseException:
        temporary.unlink(missing_ok=True)
        raise


def verify_package(path):
    with zipfile.ZipFile(path) as archive:
        names = [info.filename.replace("\\", "/")
                 for info in archive.infolist() if not info.is_dir()]
        required = {"manifest.json", "main.lua", "assets_transform.lua",
                    "README.md", "LICENSE"}
        missing = sorted(required.difference(names))
        if missing:
            raise SystemExit("FAIL: public ZIP missing: " + ", ".join(missing))
        forbidden = sorted(name for name in names
            if name.startswith("g1gpp/")
            or name.startswith("developer_tools/")
            or name in PUBLIC_EXCLUDES
            or PurePosixPath(name).suffix.lower() in common.BANNED)
        if forbidden:
            raise SystemExit("FAIL: forbidden public entries: " + ", ".join(forbidden))
        manifest = json.loads(archive.read("manifest.json"))
        if manifest.get("id") != "g1gpp":
            raise SystemExit("FAIL: unexpected public mod id")
        if manifest.get("version") != "1.0.0-beta":
            raise SystemExit("FAIL: unexpected public version")
        if manifest.get("games") != ["red", "blue", "yellow",
                                     "gold", "silver", "crystal"]:
            raise SystemExit("FAIL: unexpected public game declarations")
        main = archive.read("main.lua")
        if b"DEVELOPMENT_BUILD_NOTICE.txt" not in main:
            raise SystemExit("FAIL: public debug sentinel guard is missing")
        if "DEVELOPMENT_BUILD_NOTICE.txt" in names:
            raise SystemExit("FAIL: development sentinel packaged")
        return len(names)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", type=Path,
                        default=Path.home() / "Downloads")
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--replace", action="store_true")
    args = parser.parse_args()
    started = time.monotonic()
    config = json.loads(CONFIG.read_text(encoding="utf-8"))
    manifest = json.loads((MOD / "manifest.json").read_text(encoding="utf-8"))
    luajit, modkit, data, assets, gold = common.verify_toolchain(config)
    env = os.environ.copy()
    env.update({
        "MODKIT_LUAJIT": str(luajit),
        "LUA": str(luajit),
        "POKEPORT_DATA_DIR": str(data),
        "POKEPORT_ASSET_DIR": str(assets),
        "POKEPORT_GOLD_ROOT": str(gold),
    })

    common.run("G1GPP source preflight",
        [sys.executable, str(ROOT / "tools" / "check_lua_structure.py")], env)
    for test in sorted((ROOT / "tools" / "tests").glob("*_spec.lua")):
        common.run(f"Lua behavior: {test.stem}",
            [str(luajit), str(test), str(ROOT)], env)
    common.run_quiet("Git whitespace check", ["git", "diff", "--check"], env)

    with tempfile.TemporaryDirectory(prefix="g1gpp-public-") as temp:
        stage = Path(temp) / "g1gpp"
        stage.mkdir()
        stage_public_mod(stage)
        common.run_quiet("Official strict public validation",
            [sys.executable, str(modkit), "validate", str(stage),
             "--strict", "--base", "imported"], env)
        common.run_quiet("Official public captured-content lint",
            [sys.executable, str(modkit), "lint", str(stage)], env)

        if args.check_only:
            print(f"\nPASS: public release checks in {time.monotonic() - started:.2f}s")
            return 0

        output = args.output_dir / f"G1GPP-v{manifest['version']}.zip"
        if output.exists() and not args.replace:
            raise SystemExit(f"FAIL: output already exists: {output}")
        temporary = package(stage, output)
        try:
            count = verify_package(temporary)
            temporary.replace(output)
        except BaseException:
            temporary.unlink(missing_ok=True)
            raise

    print(f"\nPASS: {count} public files packaged in {time.monotonic() - started:.2f}s")
    print(f"ZIP: {output}")
    print(f"SHA-256: {common.sha256(output)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
