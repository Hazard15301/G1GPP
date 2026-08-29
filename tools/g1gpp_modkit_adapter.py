#!/usr/bin/env python3
"""Run the pinned official modkit with the player's asset cache mounted read-only.

The official headless driver injects mod files but not assets/generated. G1GPP's
release-safe transform recipes intentionally read that player-owned cache, so
validation otherwise stops before loading main.lua. This adapter changes only
the generated in-memory driver; the pinned official modkit remains untouched.
"""

from pathlib import Path
import importlib.util
import json
import os
import sys


def fail(message):
    print(f"g1gpp modkit adapter: {message}")
    raise SystemExit(2)


def main():
    modkit_path = os.environ.get("G1GPP_MODKIT")
    asset_dir = os.environ.get("POKEPORT_ASSET_DIR")
    gold_dir = os.environ.get("POKEPORT_GOLD_ROOT")
    if not modkit_path or not Path(modkit_path).is_file():
        fail("G1GPP_MODKIT does not name the pinned tools/modkit.py")
    if not asset_dir or not Path(asset_dir).is_dir():
        fail("POKEPORT_ASSET_DIR does not name assets/generated")
    if not gold_dir or not Path(gold_dir).is_dir():
        fail("POKEPORT_GOLD_ROOT does not name an imported Gold cache")

    spec = importlib.util.spec_from_file_location("g1gpp_official_modkit", modkit_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    root = Path(asset_dir).resolve().as_posix().rstrip("/") + "/"
    gold_root = Path(gold_dir).resolve().as_posix().rstrip("/") + "/"
    declaration = ("local ASSET_ROOT = " + json.dumps(root) + "\n"
                   + "local GOLD_ROOT = " + json.dumps(gold_root) + "\n")
    template = module.DRIVER_TEMPLATE.replace(
        "local FILES = %s\nlocal overlay = {}",
        "local FILES = %s\n" + declaration + "local overlay = {}",
        1,
    )
    template = template.replace(
        "local function readDisk(path)\n  local disk = FILES[path]",
        "local function readDisk(path)\n"
        "  local disk = FILES[path]\n"
        "  if not disk and path:sub(1, 17) == 'assets/generated/' then\n"
        "    disk = ASSET_ROOT .. path:sub(18)\n"
        "  elseif not disk and path:sub(1, 5) == 'gold/' then\n"
        "    disk = GOLD_ROOT .. path:sub(6)\n"
        "  end",
        1,
    )
    template = template.replace(
        "    if overlay[path] or FILES[path] then return { type = \"file\" } end",
        "    if overlay[path] or FILES[path] then return { type = \"file\" } end\n"
        "    if path:sub(1, 17) == 'assets/generated/' then\n"
        "      local handle = io.open(ASSET_ROOT .. path:sub(18), 'rb')\n"
        "      if handle then handle:close() return { type = 'file' } end\n"
        "    end",
        1,
    )
    template = template.replace(
        "    if path:sub(1, 17) == 'assets/generated/' then\n"
        "      local handle = io.open(ASSET_ROOT .. path:sub(18), 'rb')\n"
        "      if handle then handle:close() return { type = 'file' } end\n"
        "    end",
        "    if path:sub(1, 17) == 'assets/generated/' then\n"
        "      local handle = io.open(ASSET_ROOT .. path:sub(18), 'rb')\n"
        "      if handle then handle:close() return { type = 'file' } end\n"
        "    elseif path:sub(1, 5) == 'gold/' then\n"
        "      local handle = io.open(GOLD_ROOT .. path:sub(6), 'rb')\n"
        "      if handle then handle:close() return { type = 'file' } end\n"
        "    end",
        1,
    )
    module.DRIVER_TEMPLATE = template
    return module.main(sys.argv[1:])


if __name__ == "__main__":
    raise SystemExit(main())
