# Gen I Glitch Preservation Project (G1GPP)

G1GPP preserves classic Pokémon Red and Blue glitch behavior in Gen1Recomp
while containing destructive outcomes inside reversible, save-conscious
systems. It also includes Pikablu/Marill content and the Pokémon Center PC
SNAKE minigame.

## Compatibility

- Pokémon Red and Blue are confirmed.
- Pokémon Yellow is supported provisionally and still needs dedicated testing.
- Gen1Recomp 0.2.36 or another compatible 0.2.x release is required.
- Gold, Silver, or Crystal must be imported for Marill graphics; G1GPP gameplay
  itself remains inactive in those editions.

G1GPP uses the `overhaul` profile and may conflict with other mods that replace
the same encounters, maps, battle presentation, PC menus, or save behavior.

## Installation

1. Import `G1GPP-v1.0.0-beta.zip` through Gen1Recomp's normal **Import mod
   .zip** option.
2. Enable G1GPP for at least one imported copy of Gold, Silver, or Crystal and
   launch that edition once. This derives Marill graphics locally from your own
   imported cache.
3. Enable G1GPP for Red or Blue and play normally.

Do not install the source directory or an older private build alongside the
public package. Private builds using the old `trainer_fly` ID should be removed
before installing this release.

## Highlights

- Trainer-Fly and Ditto memory behavior, including restored glitch Pokémon and
  bounded glitch-Trainer outcomes.
- Red/Blue Old Man coast encounters.
- MissingNo. sixth-item bit-7 duplication and tileset-dependent quantity
  glyphs.
- Fight Safari Zone encounters and the Safari save/reload Glitch City route.
- Recoverable Glitch City visuals, reversed live music, and clean map/NPC/music
  restoration.
- Pikablu/Marill and Bill's Secret Garden quest.
- Cycling Road no-Bicycle behavior.
- Pokémon Center PC SNAKE minigame with persistent high scores.
- Safe capture, party, Pokédex, save/load, and display handling for restored
  glitch species.

## Marill asset policy

No extracted game artwork is distributed. `assets_transform.lua` reconstructs
required graphics from games the player has already imported into Gen1Recomp.
At least one of Gold, Silver, or Crystal is therefore required for Marill.

## Save safety and removal

G1GPP avoids permanent base-map replacements and keeps its state in mod-owned
storage or its own save namespace. Removing the mod restores ordinary game
content. As with any beta that intentionally recreates glitches, keep a normal
backup of an important save.

Compatible save state from legacy private builds migrates from the old
`trainer_fly` namespace. SNAKE unlocks and high scores may reset once because
Gen1Recomp isolates that storage by mod ID.

## Reporting problems

Include the game edition, Gen1Recomp version, other enabled mods, and exact
reproduction steps. G1GPP also writes a mod-local `g1gpp_debug.log` that may
help diagnose a report.

## License

G1GPP source code is released under the MIT License. Pokémon and related names
and imagery belong to their respective owners. This independent fan project is
not affiliated with or endorsed by Nintendo, Game Freak, Creatures, or The
Pokémon Company.
