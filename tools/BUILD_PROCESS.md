# G1GPP Build Process

Copy `tools/build_toolchain.example.json` to
`tools/build_toolchain.json`, then replace the example paths with the local
LuaJIT, pinned Gen1Recomp modkit, and imported player-cache locations. The
local configuration is ignored by Git and can also be overridden with the
environment variables used by the build scripts.

## Public release

Run from the repository root:

```powershell
python tools/build_public_release.py
```

This stages an independent public file set, omits the development sentinel and
all debug-menu modules, adds the MIT license, runs the official API-2 strict
validator and captured-content lint against that exact stage, and creates the
root-layout GitHub asset `G1GPP-v1.0.0-beta.zip`. It rejects wrapped ZIPs,
debug-only files, and all prohibited binary game assets. Use `--check-only` to
run every gate without producing a ZIP, or `--replace` only when deliberately
rebuilding the same candidate.

## Private development build

Run from the repository root:

```powershell
python tools/build_g1gpp.py
```

The command verifies the pinned LuaJIT hash, parses every Lua file, enforces the
179-local architecture limit and required feature contracts, runs Gen1Recomp's
focused headless Lua behavior tests, runs Gen1Recomp's 0.2.36 loader against
the imported Red data and read-only player asset cache,
runs the captured-content lint, checks whitespace, creates a deterministic ZIP
in Downloads, and proves every packaged byte matches source.

Known modkit warnings are fingerprinted as an exact reviewed baseline. A new,
removed, or altered warning stops the build for review instead of disappearing
into a long console listing. The current loader baseline is 38 raw glitch-type
reference warnings plus the imported-encounter comparison warning; lint retains
only that comparison warning.

Use `--check-only` while iterating when no ZIP is needed. The command refuses to
overwrite an existing package, so a manifest version must be advanced before a
new distributable is created. `--replace` is reserved for rebuilding the same
version after a packaging-tool correction; replacement occurs only after the
new temporary ZIP passes byte-identity and prohibited-content verification.

Pinned paths and hashes live in `tools/build_toolchain.json`. Environment
variables `G1GPP_LUAJIT`, `G1GPP_MODKIT`, `POKEPORT_DATA_DIR`, and
`POKEPORT_ASSET_DIR` can override paths without editing the script.

Gen1Recomp v0.2.19 or newer is the effective runtime minimum for build
12.13.127 and later Cycling Road work. Earlier engines accept the module's
scripted-movement call but ignore its collision-safety option. The pinned
v0.2.36 validator includes that support and the subsequent session-cleanup
fixes.

The modkit adapter changes only the temporary headless driver generated in
memory. It exposes `assets/generated` read-only because G1GPP's transform recipe
legally depends on the player's imported cache. The pinned official modkit file
is never modified.

## Public packaging differences

The upstream publishing and Mod Index rules are enforced by the separate public
packaging mode. It:

- place `manifest.json`, `main.lua`, and all other mod files at the ZIP root;
- exclude `developer_tools/`, `DEVELOPMENT_BUILD_NOTICE.txt`, launch helpers,
  user-specific paths, logging mirrors, captures, and research-only material;
- run official `validate --strict` and `lint` against the exact staged public
  source, not only the compatibility adapter;
- verify explicit API 2 manifest metadata;
- preserve the deterministic byte/hash and banned-content checks already used
  by the development builder; and
- preferably name the GitHub Release asset `<mod-id>-<version>.zip` for the
  launcher's update/version and Mod Index paths.

Do not repurpose a development ZIP as a public package. Only the output of
`build_public_release.py` is eligible for GitHub Release or Mod Index testing.
