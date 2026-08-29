#!/usr/bin/env python3
"""G1GPP source preflight.

This guard exists because Lua 5.1 rejects a function with more than 200 active
locals. G1GPP's historical monolithic main.lua hit that ceiling twice. We keep
a safety margin and require substantial systems to live in modules.
"""
from pathlib import Path
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "g1gpp"
MAIN = MOD / "main.lua"
MANIFEST = MOD / "manifest.json"
# No-growth architecture guard. The accepted mod initializer currently has 179
# top-level locals. New feature work must create/extract a coherent module rather
# than consume the remaining Lua 5.1 slots. 185 remains the documented outer
# emergency ceiling; Lua's absolute function limit is 200.
LOCAL_BUDGET = 179


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
        fail("g1gpp/modules/debug_logger.lua is missing")
    song_cry = MOD / "modules" / "song_cry_compat.lua"
    if not song_cry.is_file():
        fail("g1gpp/modules/song_cry_compat.lua is missing")
    audio = song_cry.read_text(encoding="utf-8")
    for required in ("Music.play(data, label, true", "Music_Routes4",
                     "TF_GLITCH_201", "TF_GLITCH_214"):
        if required not in audio:
            fail(f"persistent song-cry contract is missing {required!r}")
    if "debug_test_214_pokedex" in text:
        fail("retired temporary index-214 Pokedex test action is still present")
    anomaly = MOD / "modules" / "pokedex_anomaly_recovery.lua"
    if not anomaly.is_file():
        fail("g1gpp/modules/pokedex_anomaly_recovery.lua is missing")
    anomaly_text = anomaly.read_text(encoding="utf-8")
    for required in ("renderer.screenVeil = { 0, alpha }",
                     'love.graphics.rectangle("fill", -2048, -2048, 4096, 4096)'):
        if required not in anomaly_text:
            fail(f"full-display index-214 blackout contract is missing {required!r}")
    cycling = MOD / "modules" / "cycling_road_no_bicycle.lua"
    if not cycling.is_file():
        fail("g1gpp/modules/cycling_road_no_bicycle.lua is missing")
    cycling_text = cycling.read_text(encoding="utf-8")
    for required in ('Input:isDown("left")', 'Game.save.onBike = true',
                     'Game.save.forcedBike = true', 'ev.warp.x == 0',
                     'bicycleOwned='):
        if required not in cycling_text:
            fail(f"Cycling Road no-Bicycle contract is missing {required!r}")
    for required in ('label = "CYCLING RD - NORTH", mapId = "ROUTE_16"',
                     'label = "CYCLING RD - SOUTH", mapId = "ROUTE_18"',
                     'x = 25, y = 10, facing = "left"',
                     'x = 41, y = 8, facing = "left"'):
        if required not in text:
            fail(f"Warp Anywhere Cycling Road contract is missing {required!r}")


def check_version(text):
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    version = manifest.get("version")
    if not version:
        fail("manifest.json has no version")
    if version not in text:
        fail(f"manifest version {version!r} is not present in main.lua")


def optional_lua_parse():
    compiler = (os.environ.get("MODKIT_LUAJIT") or shutil.which("luac")
                or shutil.which("luac5.1") or shutil.which("luajit"))
    if not compiler:
        print("NOTE: no luac/luajit found; structural checks ran, compiler parse skipped")
        return
    for path in sorted(MOD.rglob("*.lua")):
        if Path(compiler).name.startswith("luajit"):
            handle = tempfile.NamedTemporaryFile(suffix=".ljbc", delete=False)
            handle.close()
            try:
                proc = subprocess.run([compiler, "-b", str(path), handle.name],
                                      capture_output=True, text=True)
            finally:
                Path(handle.name).unlink(missing_ok=True)
        else:
            proc = subprocess.run([compiler, "-p", str(path)],
                                  capture_output=True, text=True)
        if proc.returncode:
            fail(f"Lua parse failed for {path.relative_to(ROOT)}: {proc.stderr.strip()}")
    print("PASS: Lua compiler parse")


def main():
    text = MAIN.read_text(encoding="utf-8")
    records = count_main_top_level_locals(text)
    count = len(records)
    print(f"main.lua initializer top-level locals: {count}/{LOCAL_BUDGET} no-growth baseline (Lua hard limit 200)")
    if count > LOCAL_BUDGET:
        recent = "\n".join(f"  {n}: {decl}" for n, decl in records[-12:])
        fail("main.lua no-growth baseline exceeded; extract a coherent system into a module before packaging. Do not raise this guard for ordinary feature work.\n" + recent)
    check_required_modules(text)
    check_version(text)
    optional_lua_parse()
    print("PASS: G1GPP Lua structure preflight")


if __name__ == "__main__":
    main()
