# G1GPP Public Release and Discovery

Last reviewed against the upstream Gen1Recomp documentation and community mod
index on 2026-08-29. The pinned development validator is official Gen1Recomp
v0.2.36 (`fc56b9b05f01c559610c71f801355abfa4ae920f`). Recheck upstream at the
start of every development session and immediately before publishing.

## Current upstream rules

The current publishing rules are more explicit and more automated than the
rules G1GPP originally documented, but the central restriction has not changed:

- Do not distribute ROMs, save states, extracted sprites, extracted PNGs,
  chip-audio banks, or IPS/BPS/UPS patches.
- Original project-created assets may ship.
- Art derived from the games must ship as an asset-transform recipe that runs
  against the player's own imported cache.
- The release must pass both official commands:

  ```text
  python tools/modkit.py validate g1gpp --strict
  python tools/modkit.py lint g1gpp
  ```

- A release ZIP must contain `manifest.json`, the entry file, and the remaining
  mod files directly at the archive root. It must not wrap them in another
  `g1gpp/` directory.
- Manifest metadata and index metadata must agree, especially `id`, `api`,
  `profile`, permissions, dependencies, and conflicts.
- Declared permissions must match the code. G1GPP currently needs
  `engine_internals`; it does not presently need network or filesystem access in
  the public package.
- A public listing must be presented as the author's independent work, without
  official branding or an implication of endorsement.

Official references:

- Publishing: https://github.com/bryanthaboi/gen1recomp/wiki/Guide-Publishing
- Manifest: https://github.com/bryanthaboi/gen1recomp/wiki/Reference-Manifest
- Art pipeline: https://github.com/bryanthaboi/gen1recomp/wiki/Guide-Art-Pipeline
- Modkit: https://github.com/bryanthaboi/gen1recomp/wiki/Guide-Modkit
- Index rules: https://github.com/bryanthaboi/gen1recomp-mod-index/blob/main/CONTRIBUTING.md

## Discovery: the Gen1Recomp mod browser

Gen1Recomp's launcher now includes a **Find Mods** interface. It consumes a
community index rather than searching arbitrary GitHub repositories.

The official community index is:

- Repository: https://github.com/bryanthaboi/gen1recomp-mod-index
- Submission helper: https://bryanthaboi.github.io/gen1recomp-mod-index/
- Machine-readable feed:
  https://bryanthaboi.github.io/gen1recomp-mod-index/data/index.json

The index contains only metadata, description text, and an optional thumbnail.
G1GPP's code and release ZIP remain in the G1GPP repository. Players add an
index source to the launcher; no index is assumed to be trusted automatically.

For normal discoverability and updates:

1. Make the G1GPP source repository public.
2. Set the manifest `github` field to `Hazard15301/G1GPP`.
3. Publish the installable GitHub Release ZIP as
   `G1GPP-v1.0.0-beta.zip`.
4. Add the official Gen1Recomp release workflow or reproduce its root-level ZIP
   layout exactly.
5. Submit the listing through the index submission helper. The helper opens the
   pull request and validates the same metadata schema as index CI.
6. After acceptance, publish later versions as GitHub Releases. The index's
   nightly job discovers them automatically; a new listing pull request is not
   required for each version.

An index listing is discoverability, not endorsement or a safety certification.

## Canonical identity

The public mod ID is `g1gpp`, the source directory is `g1gpp/`, and the public
release asset is `G1GPP-v1.0.0-beta.zip`. Private development builds predating
the public beta used the internal ID `trainer_fly`. G1GPP migrates compatible
Pokémon-save state from that legacy namespace and can temporarily read its
previously derived Marill art. Gen1Recomp's private per-mod storage cannot be
safely opened under another mod ID, so a private-build SNAKE unlock or high
score may reset once during this deliberate identity migration.

## Current audit results

### Passing

- `modkit lint g1gpp` reports no ROM-derived content.
- The current development ZIP contains no PNG, audio, ROM, save-state, patch,
  or other banned binary game assets.
- Derived graphics are implemented through `assets_transform.lua`.
- The manifest already declares `engine_internals`, matching the source's
  internal engine imports.
- The repository already has the correct public GitHub remote:
  `https://github.com/Hazard15301/G1GPP.git`.

### Resolved for v1.0.0-beta

- The transform now exits cleanly during cache-less headless validation while
  continuing to derive every runtime graphic from an ordinary player cache.
- `build_public_release.py` produces the required root-layout ZIP and validates
  the exact staged files.
- The public stage excludes the development sentinel, developer tools, debug
  menu modules, test viewers, launch helpers, and redundant inspection data.
- The manifest now declares API 2, the `overhaul` profile, link impact, engine
  range, repository, dependencies/conflicts, and `1.0.0-beta` identity.
- MIT is the selected source-code license, with public README and release notes.
- The twenty-source-second reversed-audio path passed live stock and FRLG music
  testing without an apparent delay; map/NPC/music recovery also passed.

### Remaining publication actions

- The exact public ZIP has now installed through the ordinary launcher and its
  SNAKE unlock/gameplay/storage path passed on an existing Blue save. Remaining
  clean-save and targeted Red/Blue smoke tests are recommended but not required
  by the current release decision.
- Confirm the Marill bootstrap from at least one clean Gold/Silver/Crystal
  import, followed by the Pikablu quest in a clean public Red/Blue install.
- Publish the GitHub prerelease and verify its downloaded ZIP and checksum.
- Submit the official Mod Index listing.
- Yellow remains explicitly provisional until its dedicated pass is complete.

## Public release gate

A build may be called a public release candidate only when all of the following
are true:

- [ ] Latest upstream Gen1Recomp release, wiki, publishing guide, manifest
      reference, modkit guide, and index contribution rules checked that day.
- [x] Clean source tree reviewed; no private captures, secrets, hard-coded user
      paths, or development-only tools are included.
- [x] `validate --strict` passes on the staged public source with an ordinary supported
      player import.
- [x] `lint` passes with no unreviewed findings.
- [x] Manifest explicitly declares API 2 and complete release metadata.
- [x] Public ZIP builder enforces root layout and permitted files only.
- [x] ZIP installs through Gen1Recomp's normal **Import mod .zip** flow.
- [ ] Red and Blue smoke tests pass from a clean install and a representative
      existing save.
- [ ] Yellow is either accepted through its targeted tests or excluded/labeled
      accurately.
- [ ] Compatibility smoke tests pass with no other mods and with the supported
      FRLG presentation mod.
- [ ] Disabling/removing G1GPP restores vanilla behavior and leaves no permanent
      map or save damage.
- [ ] GitHub Release, release notes, checksum, and install instructions are
      published.
- [ ] Official Mod Index listing is submitted and its download resolves.

## Recommended release sequence

1. Produce and locally install the release-candidate ZIP.
2. Run clean Red/Blue and Gen-II-to-Marill bootstrap smoke tests.
3. Publish the GitHub prerelease and verify its downloaded
   ZIP on a clean Gen1Recomp installation.
4. Submit G1GPP to the official community index.
