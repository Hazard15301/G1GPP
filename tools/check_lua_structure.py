#!/usr/bin/env python3
"""G1GPP source preflight.

This guard exists because Lua 5.1 rejects a function with more than 200 active
locals. G1GPP's historical monolithic main.lua hit that ceiling twice. We keep
a safety margin and require substantial systems to live in modules.
"""
from pathlib import Path
import json
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "trainer_fly"
MAIN = MOD / "main.lua"
MANIFEST = MOD / "manifest.json"
LOCAL_BUDGET = 185  # hard project guard; Lua's absolute function limit is 200.


def fail(message):
    print(f"FAIL: {message}")
    raise SystemExit(1)


def count_main_top_level_locals(text):
    lines = text.splitlines()
    try:
        start = next(i for i, line in enumerate(lines) if line.startswith("return function(mod)"))
    except StopIteration:
        fail("main.lua is missing the expected 'return function(mod)' initializer")
    records = []
    for number, line in enumerate(lines[start + 1 :], start + 2):
        # G1GPP formats initializer-scope declarations at exactly two spaces.
        # Nested function locals are more deeply indented and do not consume the
        # initializer's 200-local pool simultaneously.
        if line.startswith("  local "):
            records.append((number, line.strip()))
    return records


def check_required_modules(text):
    expected = 'mod.path .. "/modules/debug_logger.lua"'
    if expected not in text:
        fail("main.lua is not loading modules/debug_logger.lua through mod.path")
    if not (MOD / "modules" / "debug_logger.lua").is_file():
        fail("trainer_fly/modules/debug_logger.lua is missing")


def check_version(text):
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    version = manifest.get("version")
    if not version:
        fail("manifest.json has no version")
    if version not in text:
        fail(f"manifest version {version!r} is not present in main.lua")


def optional_lua_parse():
    compiler = shutil.which("luac") or shutil.which("luac5.1") or shutil.which("luajit")
    if not compiler:
        print("NOTE: no luac/luajit found; structural checks ran, compiler parse skipped")
        return
    for path in sorted(MOD.rglob("*.lua")):
        if Path(compiler).name.startswith("luajit"):
            # LuaJIT accepts -b for bytecode generation; -bl is not a pure parse.
            # Prefer a normal Lua compiler when present. Skip rather than execute mod code.
            print(f"NOTE: found {compiler}, but no pure parse mode configured; skipped {path.relative_to(ROOT)}")
            continue
        proc = subprocess.run([compiler, "-p", str(path)], capture_output=True, text=True)
        if proc.returncode:
            fail(f"Lua parse failed for {path.relative_to(ROOT)}: {proc.stderr.strip()}")
    print("PASS: Lua compiler parse")


def main():
    text = MAIN.read_text(encoding="utf-8")
    records = count_main_top_level_locals(text)
    count = len(records)
    print(f"main.lua initializer top-level locals: {count}/{LOCAL_BUDGET} project budget (Lua hard limit 200)")
    if count > LOCAL_BUDGET:
        recent = "\n".join(f"  {n}: {decl}" for n, decl in records[-12:])
        fail("main.lua local budget exceeded; extract a coherent system into a module before packaging.\n" + recent)
    check_required_modules(text)
    check_version(text)
    optional_lua_parse()
    print("PASS: G1GPP Lua structure preflight")


if __name__ == "__main__":
    main()
