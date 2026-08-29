# G1GPP v1.0.0-beta

The first public beta of the Gen I Glitch Preservation Project preserves a
broad collection of Pokémon Red/Blue glitch behavior in Gen1Recomp while
containing destructive outcomes inside reversible, save-safe systems.

## Compatibility

- Red and Blue: confirmed.
- Yellow: included, but dedicated version-specific testing remains incomplete.
- Gen1Recomp: 0.2.36 through the compatible 0.2.x line.
- Marill prerequisite: import Gold, Silver, or Crystal, enable G1GPP for that
  edition, and launch it once. This generates Marill graphics from the player's
  own cache. G1GPP gameplay is inactive in Gen II.

## Canonical identity

This release establishes `g1gpp` as the canonical mod ID and `G1GPP` as the
package name. Compatible Pokémon-save state from legacy private builds using
the `trainer_fly` development ID is migrated automatically. Private SNAKE
unlock/high-score storage may reset once because Gen1Recomp isolates that data
by mod ID.

## Highlights

- Trainer-Fly and Ditto memory behavior, including restored glitch Pokémon and
  bounded glitch-Trainer outcomes.
- Red/Blue Old Man coast encounters and MissingNo.'s sixth-item bit-7
  duplication with tileset-dependent quantity glyphs.
- Fight Safari Zone encounters and the Safari save/reload Glitch City route.
- Recoverable Glitch City presentation with reversed live music and clean NPC,
  map, and music restoration.
- Pikablu/Marill and Bill's Secret Garden quest.
- Cycling Road no-Bicycle behavior.
- Pokémon Center PC SNAKE minigame.
- Safe capture, party, Pokédex, save/load, and display handling for restored
  glitch species.

## Public-package guarantees

- No in-game debug menu or test shortcuts.
- No ROM, extracted game PNG, recorded game audio, save, state, or patch file.
- Derived graphics are generated from the player's own imported caches through
  Gen1Recomp's asset-transform system.
- Official API-2 strict validation and captured-content lint pass on the exact
  staged release contents.

This is a beta. Keep an ordinary backup of important saves and report the game
edition, Gen1Recomp version, enabled mods, and reproduction steps with any bug.
