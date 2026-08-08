# Trainer-Fly Glitch Preservation Mod

## Build 12.13.43 — Authentic Runtime Sprite Corruption

- Replaces the approximate artistic player-Pokémon back-sprite scramble with the exact Red/Blue transform measured from paired mGBA VRAM captures: reverse the order of the 8-pixel tile columns while leaving each column's pixels unmirrored.
- Replaces the approximate post-attack enemy-front scramble with the exact measured transform: leave every 8x8 tile in place and horizontally mirror the pixels inside each tile.
- Keeps the already-correct initial enemy whole-sprite horizontal reversal.
- All three effects are generated at runtime from Gen1Recomp's live sprite image; no species-specific pre-baked corrupted Pokémon sprite is used for these effects.
- The dedicated corrupted player-Trainer back picture is intentionally unchanged in this build; its original Red/Blue split body/head rendering path is a separate research target.
- MissingNo. TM/HM compatibility and the 12.13.42 test kit are unchanged.

# Glitch City 9 — Foreign Block Palette Probe

## Build 12.13.42 — TM/HM Compatibility Test Kit

- Adds `ADD TM/HM TEST KIT` to the G1GPP debug menu.
- Each activation adds one TM01 Mega Punch, TM12 Water Gun, and TM43 Sky
  Attack, then ensures HM01 Cut, HM02 Fly, HM03 Surf, HM04 Strength, and HM05
  Flash are present without duplicating an HM already in the Bag.
- Every requested item, successful addition, already-present HM, capacity
  failure, and final result is recorded in the persistent debug log.
- The action uses Gen1Recomp's canonical Bag API and does not bypass ordinary
  Bag capacity. This is a temporary testing utility; reload without saving to
  discard the added machines.
- All 12.13.41 compatibility, duplicate-move, Pokédex, Rhydon, sprite, Glitch
  City, and save-protection behavior remains unchanged.

## Build 12.13.41 — Red/Blue MissingNo. TM/HM Compatibility

- Normal MissingNo. on Red and Blue now uses its exact canonical 24-move
  TM/HM compatibility list, decoded from the seven compatibility bytes reached
  by the original games' wrapped No.000 base-data lookup.
- The list includes TM43 Sky Attack but excludes TM12 Water Gun, matching the
  original contradiction between MissingNo.'s starting moves and machine
  compatibility.
- The compatibility record is restricted to G1GPP's normal MissingNo. slots.
  Yellow and the Fossil/Ghost forms receive no Red/Blue compatibility data.
- The validated `WATER GUN / WATER GUN / SKY ATTACK` starting slots and all
  12.13.40 Pokédex, Rhydon, ownership, sprite, Glitch City, and save-protection
  behavior remain unchanged.

## Build 12.13.40 — Red/Blue Duplicate Water Gun Fidelity

- Normal MissingNo. on Red and Blue now starts with the canonical three slots:
  `WATER GUN / WATER GUN / SKY ATTACK`.
- The exception is restricted to G1GPP's normal MissingNo. internal indices
  31-181. Fossil/Ghost forms 182-184 remain on their existing stable path.
- Yellow does not receive the Red/Blue override; its separate data-fidelity
  implementation remains pending.
- Gen1Recomp's ordinary duplicate-move filter is unchanged for every normal
  Pokémon and every non-qualifying glitch species.
- The live debug log records `MISSINGNO MOVESET PRESERVED` with the species,
  level, game version, exact slots, and confirmation that global deduplication
  was not changed.
- All validated 12.13.39 Pokédex, Rhydon, ownership, sprite, Glitch City, and
  save-protection behavior is inherited unchanged.

## Build 12.13.39 — Blank Lore Entry and Trainer-Back Timing

- Lore-Friendly No.000 now uses an intentionally blank registered description,
  preventing Gen1Recomp's `Data unknown.` fallback while retaining canonical
  height and weight.
- Active MissingNo. sprite corruption now selects the validated corrupted,
  left-facing player Trainer back sprite during battle-intro asset resolution.
- Opposing reversal/breakage, player-Pokémon scrambling, normal-data recovery,
  Rhydon conversion, and canonical ownership reconciliation are unchanged.

## Build 12.13.38 — Canonical No.000 Data and Ownership Reconciliation

- Lore-Friendly and Enhanced now share MissingNo.'s canonical Red/Blue
  Pokédex measurements: 10'0" and 3507.2 lb.
- Lore-Friendly keeps the description blank and No.000 out of the ordinary
  Pokédex index.
- Enhanced changes only the description and adds the revisitable No.000 row.
- Rhydon conversion now preserves the canonical Pokédex ownership flag when
  another MissingNo. of the converted form still exists in party, PC boxes,
  Day Care, or orphaned storage. This keeps caught indicators and other mods
  reading the standard ownership table synchronized.

## Build 12.13.37 — MissingNo. Clean-Slate Debug Action

- Adds `WIPE MISSINGNO STATE` to the G1GPP debug menu. Its live value shows
  the number of preserved MissingNo. records currently found.
- Activating it removes every preserved MissingNo. from the party, all PC
  boxes, Day Care, and quarantine storage; clears all internal MissingNo.
  seen/owned flags; resets Cubone's shared No.000 seen gate; and clears the
  volatile inverted-sprite condition.
- Ordinary Pokémon, Cubone ownership, inventory, maps, Hall of Fame records,
  and unrelated save state are left untouched.
- Persistent logging records the before/after count and each storage class
  affected by the wipe.
- All 12.13.36 trainer-sprite, Start-menu placement, MissingNo., Glitch City,
  debug, and safety behavior is retained.

## Build 12.13.36 — Established Trainer Sprite and Menu Position

- MissingNo.'s volatile battle-sprite effect now uses G1GPP's validated
  left-facing corrupted Trainer back sprite without scrambling it again.
- Player Pokémon back-sprite and opposing-sprite corruption remain unchanged.
- The native Start-menu `G1GPP` shortcut now appears directly below the
  Trainer-name row, immediately before `SAVE`.
- All behavior and safety fixes from validated 12.13.35 are retained.

## Build 12.13.35 — Lua 5.1 Local-Limit Correction

- Corrects 12.13.34's loader failure: `function at line 644 has more than 200
  local variables`.
- The new menu renderer, Theme, OptionRows, Pokémon, Stats, and Growth helpers
  now share one module-owned state table instead of consuming separate locals
  in the already large initialization function.
- A conservative AST audit reports 198 locals, three fewer than the
  runtime-validated 12.13.33 baseline under the same counting method.
- The `G1GPP` native Start-menu shortcut and selected-label marquee behavior
  are otherwise unchanged from 12.13.34.
- 12.13.34 must be treated as broken and superseded; it never loaded, so none
  of its hooks or gameplay changes ran.

## Build 12.13.34 — Native Debug Shortcut and Scrolling Labels

- The normal in-game Start menu now contains a compact `G1GPP` row immediately
  before `MODS`. Selecting it opens this mod's options directly, without
  navigating through the general mod list and detail page.
- Pressing B from the directly opened options returns to the overworld.
- G1GPP option labels are constrained to their 16-character interior instead
  of drawing into the box border. A selected long label pauses for 0.9 seconds,
  then scrolls left at a restrained pace with a three-space loop gap.
- Only the selected label animates. Unselected labels remain stationary and
  other mods/base-game option screens retain the stock renderer.
- Persistent logging records shortcut success/failure and row count.
- All 12.13.33 Cubone flag, No.000 page, safe Rhydon conversion, presentation,
  debug, and logging behavior is retained unchanged.

## Build 12.13.33 — Deterministic MissingNo. Rhydon Glitch

- No.000 now shares its authentic capture-page condition with Cubone's seen
  flag. If Cubone is unseen, catching a preserved MissingNo. displays the
  No.000 page; closing it converts that caught record into Rhydon.
- The transformation is deterministic, never random, and occurs after the
  page but before the nickname prompt. The valid Rhydon record retains the
  caught level and DVs, receives recalculated Rhydon stats/experience, and
  receives Rhydon's normal moves for that level.
- If Cubone is already seen, the capture announcement/page is skipped and the
  caught Pokémon remains MissingNo., including on later No.000 captures.
- `CUBONE SEEN FLAG` is a debug action whose live value reads `SEEN` or
  `UNSEEN`; pressing A toggles only that flag so both paths can be tested on
  one save. The No.000 gate intentionally overrides Gen1Recomp's private,
  schema-safe MissingNo. registration when the flag is reset.
- Persistent diagnostics record the flag check, selected outcome, page
  construction, conversion timing/result, and every debug flag mutation.
- No raw save bytes, Hall of Fame data, item quantities, or unrelated Pokémon
  records are corrupted. PC hybridization and Day Care stabilization remain a
  separately scoped future authenticity pass.

## Build 12.13.28 — MissingNo. Lore-Friendly Pokédex Record

- MissingNo.'s automatic capture entry and party status page now visibly show
  **No.000**, while its registered positive internal key remains untouched for
  Gen1Recomp schema safety.
- The stable development explanation was replaced with a restrained damaged-
  record entry: `NO DATA EXISTS. / ITS FORM CHANGES / EACH TIME IT IS /
  OBSERVED.`
- Classification is now **UNKNOWN** and the fabricated physical measurements
  are zeroed.
- MissingNo. is masked from the ordinary selectable 001-151 Pokédex list after
  construction, matching its usual inaccessibility in original Red/Blue.
- Direct capture-page and party-status viewing remain available and continue to
  activate the 12.13.27 inverted-sprite condition.
- Persistent logging records preparation of the No.000 page and every ordinary
  Pokédex-list mask operation.
- All 12.13.27 inverted-sprite activation, battle progression, recovery,
  renderer cleanup, debug trigger, and corrected game-version logging remain.

## Build 12.13.27 — MissingNo. Inverted Battle Sprites

- Viewing the Pokédex entry or status screen of any preserved `MISSINGNO.`
  species now activates Generation I's volatile inverted-sprite condition.
- An affected battle begins with a tile-distorted player Trainer back picture,
  a scrambled player Pokémon back picture, and reversed opposing pictures.
- After the player's first successfully executed move reaches its animation
  redraw point, the opposing Pokémon picture changes from a clean reversal to
  a deterministic tile-scrambled form.
- Viewing the status screen or Pokédex entry of an ordinary Pokémon clears the
  effect, matching the documented original recovery method.
- The effect exists only in mod runtime memory. Pokémon records, sprite assets,
  Hall of Fame records, inventory, and save data are never changed.
- The Mods screen includes **TEST INVERTED SPRITES** to arm the identical
  volatile state without first catching MissingNo.; ordinary data still clears
  the test state normally.
- Persistent logging covers activation/rearming, each transformed role,
  affected battle entry, post-attack breakdown, recovery, renderer failure,
  canvas cleanup, and battle completion.
- Corrected 12.13.26's successful game-version detection record so
  `gameVersionError=nil` instead of displaying the returned info-table address.
- All runtime-validated Glitch City 12.13.26 behavior is otherwise unchanged.

## Build 12.13.26 — Game-Version Session Logging

- Every `SESSION START` record now identifies the active game as Red, Blue, or
  Yellow using Gen1Recomp's authoritative `GameVersion` module.
- The same version information is repeated in `MOD INITIALIZED` and
  `GAME LOADED` records so copied log excerpts remain self-describing.
- Detection failures are recorded as `gameVersion=unknown` with a diagnostic
  field instead of interrupting startup.
- All validated 12.13.25 Glitch City behavior remains unchanged.

## Build 12.13.25 — Camera-Local Glyph Drift

- The 12.13.24 log confirmed all 24 scheduled renderer rebuilds succeeded, but
  only about three mutations were noticed during play.
- The earlier five-by-four-block "visible neighborhood" exceeded the actual
  Game Boy camera area. Selection is now constrained to a three-by-two-block
  camera-local radius while still avoiding the player's immediate surroundings.
- Candidate coverage increases from roughly 26 to as many as 64 map blocks so
  the tighter camera ring retains valid targets while the player moves. Runtime
  proximity checks—not permanent activation-time exclusions—protect the player.
- Each event changes four non-collision glyph cells within one 32x32 map block,
  instead of two. The calm middle-contrast backgrounds remain mandatory.
- Timing remains one block every 75 frames (about 1.25 seconds). This increases
  visibility without increasing animation frequency, flashing, or camera motion.

## Build 12.13.24 — Rendered Glyph Drift

- Live 12.13.23 logging proved that 24 nearby mutations executed successfully,
  despite only one change being visually apparent during the test.
- Cause: `Map:setBlock` updated the runtime map state but did not reliably
  invalidate TileRenderer's cached visual map after each isolated change.
- Every mutation now invokes the renderer's lightweight `rebuild` path, with a
  full tileset-renderer reconstruction only as a failure fallback.
- Animation cadence remains one block every 75 frames (about 1.25 seconds),
  changing two non-collision glyph cells with middle-contrast backgrounds.
  Frequency and brightness were intentionally not increased until the corrected
  visual refresh is user-tested.
- Persistent mutation logging now records renderer refresh success or failure.

## Build 12.13.23 — Direct Glitch City Debug Action

- The Mods menu now includes **START GLITCH CITY** immediately after
  **START TEST BATTLE**.
- Selecting it queues the action and waits for the Mods screen to close and the
  overworld to become idle, matching the established test-battle action flow.
- The player's current map, position, facing, and music are captured as the
  recovery origin, then the production Glitch City runtime activates directly.
- Only the preceding battle is bypassed. The full 30-second timer, corrupted
  terrain and glyph drift, NPC conversations, audio, physical containment,
  interaction restrictions, map restoration, origin return, and recovery
  presentation run normally.
- START TEST BATTLE and START GLITCH CITY clear each other's queued state.
- Persistent logging records queueing, start request, success or failure, and
  the existing complete containment/recovery lifecycle.

## Build 12.13.22 — Visible Glyph Drift Rebalance

- Live testing confirmed that 12.13.21 performed twenty mutations, but most of
  its ten eligible blocks were outside the visible play area.
- The candidate pool is now distributed across up to 36 blocks. Runtime
  selection targets the player's visible neighborhood while continuing to skip
  the immediate surrounding area.
- One block changes about every 1.25 seconds, and each variant changes two
  non-collision glyph cells instead of one. Only one block changes per event.
- Middle-contrast opaque backgrounds, fixed collision geometry, containment,
  recovery, and all other validated behavior remain unchanged.

## Build 12.13.21 — Subtle Glyph Drift

- A maximum of ten scattered map blocks receive prebuilt visual variants.
- One eligible block changes approximately every 1.5 seconds. Blocks near the
  player are skipped, preventing distracting changes directly underfoot.
- Each change replaces only one non-collision glyph position and uses the two
  middle-contrast opaque background themes. There are no screen flashes,
  rapid white/black swaps, camera movement, or coordinate manipulation.
- Every variant copies its base block's four collision-defining tile positions
  exactly. Containment, obstacles, movement geometry, and recovery are fixed.
- Persistent logging records animation installation and every subtle mutation.

## Build 12.13.20 — Opaque UI-Glyph Terrain

- Glitch City terrain now deliberately favors verified punctuation, brackets,
  arrows, triangles, currency/gender marks, and text-box border pieces instead
  of selecting uniformly from the complete font pages.
- Every glyph tile is baked over a solid background. Four contrast themes are
  included: white/black, light/black, dark/white, and black/white. Game Boy
  shade values allow the active edition/display palette to tint them normally.
- Glyphs are injected only into non-collision-defining tile positions. The four
  collision positions in every metatile retain the existing validated safety
  templates or controlled obstacle values.
- Derived glyph atlases now cover every tileset present in the live Blue and
  Yellow extractions, including Pokémon Centers, spinners, flowers, and
  Yellow's Beach House.
- The original tileset image, blocks, collision, warp and connection state are
  still snapshotted and restored exactly during recovery.

## Build 12.13.19 — JACRED/ZZAZZ Variety and Left-Facing Sprite

- Generated glitch names now account for 70% of JACRED and ZZAZZ Bag battle
  headers, exactly double the previous 35% rate.
- The remaining 30% keeps approximately the previous relative mix: 12%
  Pokémon names, 7% blank, 7% trainer classes, and 4% literal `JACRED`.
- Standard JACRED and ZZAZZ Bag variants keep independent eight-name recent
  histories. Selection rerolls recent duplicates and falls back to a newly
  generated glyph name if fixed categories cannot produce a fresh result.
- The corrupted trainer back sprite now faces left. The replacement was
  already packaged and is the exact pixel-for-pixel horizontal mirror of the
  validated artwork, so its content, dimensions, palette, and placement are
  unchanged.
- Battle mechanics, variant selection, fake Bag behavior, safe exits, victory
  warning, Glitch City, recovery, and save protection are unchanged.

## Build 12.13.18 — JACRED Expanded-Glyph Names

- JACRED's existing 35% garbage-name outcome now uses the complete verified
  corruption pool introduced for Glitch City NPC dialogue.
- Garbage names may contain arrows, triangles, box pieces, currency/gender
  marks, full-width forms, typographic symbols, lowercase letters, and kana.
- The original outcome weights remain unchanged: 35% garbage, 25% Pokémon,
  15% blank, 15% trainer class, and 10% literal `JACRED`.
- Display names remain limited to ten visible glyphs. Length limiting now uses
  the recomp's font spans so a multi-byte symbol or kana character can never be
  cut in half.
- JACRED's internal `TF_JACRED` identity, battle behavior, sprites, music,
  corrupted Bag, safe exit, and victory warning are unchanged.

## Build 12.13.17 — Expanded Glitch Glyphs

- Corrupted NPC dialogue now draws from the recomp's verified Gen-I character
  map: upper/lowercase Latin, numbers, typography, currency and gender marks,
  arrows, triangles, box-drawing pieces, full-width forms, and kana.
- Symbol and kana groups are weighted prominently so repeated conversations
  produce visibly different corruption rather than mostly scrambled English.
- Blue, Yellow, and the loader's shared font assets were compared directly and
  are byte-identical. These characters use the required local edition font and
  do not depend on another game version being installed.
- The validated one-page limit, NPC-only targeting, script suppression, battle
  blocking, containment, recovery, and persistent dialogue logging are intact.

## Build 12.13.16 — Glitched NPC Dialogue

- Pressing A toward an NPC or stationary trainer during Glitch City now opens
  a short, randomized corrupted dialogue box.
- The dialogue preserves the source text's approximate spacing and line shape,
  is limited to one compact page, and is regenerated for each interaction.
- Real NPC and trainer scripts remain completely suppressed: no battles,
  items, flags, movement commands, shops, healing, or other side effects run.
- Moving NPCs may be addressed and remain frozen only while their corrupted
  dialogue box is open.
- Signs, hidden objects, terminals, switches, bookshelves, and map-object
  scripts remain inert.
- Persistent diagnostics record dialogue opening and closing, NPC identity,
  trainer status, movement status, and source/output lengths.

This build keeps all corruption inside the actual runtime world. It adds no
screen overlay. In addition to rearranging blocks already used by the current
map, it attempts to discover valid metatiles from the active tileset that the
map normally never uses and injects those into the corrupted block grid.

These foreign blocks are still real world geometry: they scroll with the map,
carry their native collision, and are removed by the existing exact recovery.
If a particular engine build does not expose the full tileset palette, the mod
falls back safely to the proven Glitch City 8 block corruption.

This is the first runtime foreign-graphics probe. It does not yet extract or
ship raw ROM graphics. A later milestone can build a local ROM-derived tile
cache after the imported-asset path is confirmed.

# Build Notes — Glitch City 6

## Glitch City 7 Safety / Recovery Test

- Natural Glitch City duration is approximately 30 seconds.
- Natural recovery restores the captured map, coordinates, and facing.
- Wild encounters, trainer sight battles, and scripted battles are suppressed while active.
- SAVE is visibly inaccessible and the cancellable `save.write` hook rejects progress-save writes before world capture or disk I/O.
- Entry: `MEMORY OVERWRITE DETECTED! / WORLD DATA HAS BEEN CORRUPTED.`
- Exit: `WORLD DATA RECOVERED. / YOUR SAVE FILE WAS PROTECTED FROM DAMAGE.`


- Natural Glitch City timeout now restores the clean map and warps the player to the exact pre-battle map, coordinates, and facing.
- Genuine map escape still ends corruption without pulling the player back.
- Runtime block corruption is denser and more repetitive.
- Stable text-like tile artifacts are added across the overworld using Gen-I-style characters.
- Direct test battle action from Glitch City 5 remains available.

# Gen 1 Glitch Preservation Project (G1GPP)

## Glitch City Handoff Safety Probe

This test build is rebuilt from the Jacred30.13 stable checkpoint. It removes
the temporary Jacred startup and fake-Bag diagnostic messages.

For the qualifying ZZAZZ hidden-Poke-Ball exit only, it waits until the stable
recovery pages and native battle teardown have completed, then waits 30 idle
overworld frames before displaying the protected-save corruption warning.

It intentionally contains no map corruption, reversed audio, draw overrides,
automatic recovery, save interception, or warp listeners. Its only purpose is
to prove the battle-to-overworld handoff without reintroducing the crash from
the withdrawn audio-probe build.



A preservation-focused Gen1Recomp mod dedicated to recreating canonical
Pokémon Red and Blue glitches as accurately and safely as practical.

The project began as a Trainer-Fly restoration, but now includes preserved
glitch Pokémon, MissingNo. forms, glitch Trainers, Jacred, ZZAZZ behavior,
controlled crash recreations, and reusable recovery systems.

## Included in v1.0

- Original Nugget Bridge Trainer-Fly setup.
- Teleport escape and forced return Start menu.
- Live enemy Special-stat capture, including Transform/current stats.
- Debug Special fast path for testing any byte value.
- Centralized Special-index encounter resolver.
- Normal Pokémon encounters through Gen1Recomp's internal index table.
- Every captured unused/MissingNo. slot from indices 1-190.
- Exact index-specific 56x56 front sprites from the Pokémon Blue capture run.
- Real, level-7, catchable, save-safe glitch Pokémon.
- Safe classification of known fatal values:
  - 193, 196, 199
  - 248-255
- Upper-range trainer values are recognized and clearly deferred to the next
  trainer-battle implementation milestone rather than misidentified as species.

## Important safety differences

The mod never stores invalid ROM pointers or intentionally crashes the recomp.
Glitch Pokémon use explicit registered species records. Fatal outcomes use
controlled visual sequences and return the player safely.

The original hardware's item duplication, Hall of Fame corruption, save
corruption, and arbitrary-code side effects are not reproduced.

## Quick tests

Enable **DEBUG SPECIAL** in the Mods menu.

- `21` — Mew control.
- `31`, `32`, `50` — captured MissingNo. slots.
- `182` — Fossil Kabutops.
- `183` — Fossil Aerodactyl.
- `184` — Ghost.
- `193` — safe blank-lock class.
- `248` — safe persistent-corruption class.
- `252` — safe white-failure class.

## Next milestone

Trainer-producing upper indices will be routed into real trainer battle
initialization using the captured upper-range WRAM/graphics data. Crash effects
will then receive their LCD-accurate captured visuals and audio timing.


## v1.0.1 loader fix

The generated encounter table is embedded directly in `main.lua`. The
separate `data/encounters.lua` remains included for inspection, but the mod
does not open it at runtime.


## v1.0.2 Special-value editor

- Highlighting **SPECIAL VALUE** no longer allows left/right adjustment.
- Press **A** to open the dedicated `×##` editor.
- Up/down changes the value immediately.
- Holding a direction pauses briefly, repeats slowly, then accelerates.
- The editor supports the full byte range `0–255`, including zero.
- **A** confirms; **B** cancels without changing the stored value.


## v1.0.3 fossil and Ghost resolver fix

Indices `182`, `183`, and `184` are special graphics entries in the original
ROM rather than ordinary registered Pokémon species. They are now explicitly
registered as safe Trainer-Fly encounters:

- `182` — Fossil Kabutops-form MissingNo.
- `183` — Fossil Aerodactyl-form MissingNo.
- `184` — Ghost-form MissingNo.

Each uses its exact captured 56×56 front sprite.


## v1.1.0-alpha2 — authentic trainer-table preview

This alpha implements the portion of the Ditto-glitch trainer loader that can
be reproduced exactly from Gen1Recomp's extracted Pokémon Blue trainer data.

- Special `201–247` selects trainer class `1–47`.
- Attack Modifier `1–13` selects the trainer set; neutral is `7`.
- The party reader crosses trainer-class boundaries exactly like Red/Blue's
  `ReadTrainer` routine.
- Empty unused classes fall directly into the following class's data.
- The displayed trainer keeps its own built-in name, portrait, AI and music,
  even when its party bytes came from a later class.
- Class-zero Jacred (`200`) is reserved for its separate decoder.
- Values `248–255` are no longer confused with the earlier grass-injection
  crash tests. ZZAZZ values are identified but safely blocked.
- Reads beyond Lance are stopped safely until the out-of-table ROM decoder is
  implemented.

### Debug tests

Enable **DEBUG SPECIAL**.

Suggested combinations:

- `201 / ATTACK MOD 1` — Youngster, first valid Youngster party.
- `201 / ATTACK MOD 7` — Youngster, seventh party.
- `226 / ATTACK MOD 1–3` — Professor Oak's three unused teams.
- `227 / ATTACK MOD 1` — Chief presentation, party bytes fall into Scientist.
- `247 / ATTACK MOD 1` — Lance.
- `247 / ATTACK MOD 7` — safely blocked after reading beyond trainer data.

This is an alpha test build. Keep v1.0.3 as the stable release.


## v1.1.0-alpha3 — Jacred and captured crash outcomes

- Special `200` now launches a real trainer battle named **JACRED**.
- Jacred preserves the captured class-zero/level-255 semantics while replacing
  invalid species zero with the mod's preserved MissingNo. body so the recomp
  remains stable.
- Special `248` uses the persistent corrupted-battle/freeze outcome.
- Special `252` uses the immediate white-screen outcome and does not play the
  low-health alarm.
- Special `254` uses the corrupted-battle-then-blank outcome.
- `201–247` behavior is unchanged from alpha2.
- No actual memory overflow, save corruption, or emulator crash occurs.

This alpha uses safe fades and timing to validate behavioral routing. The
captured corrupted battle framebuffer/back-sprite presentation remains part of
the later crash-effects rendering pass.


## v1.1.0-alpha4 — captured visual-effect engine

- Jacred now uses the captured Special-200 glitch image instead of Youngster.
- Special 248 displays the captured transition and canonical frozen corrupted
  battle screen while the low-health alarm loops.
- Special 252 displays the captured transition and white failure with no alarm.
- Special 254 displays transition, corrupted battle, and blank-lock frames while
  the alarm loops.
- Effects are full-screen 160×144 captures rendered inside the recomp.
- A/B may recover after the minimum hold time; otherwise recovery is automatic.
- Recovery stops the alarm and returns safely with an instability message.

This is the first implementation of the reusable Glitch Effect Screen.


## v1.1.0-alpha5 — native battle bridge

Crash recreations no longer jump directly from the overworld into an overlay.

- Specials `248`, `252`, and `254` now start a real temporary trainer battle.
- Gen1Recomp therefore runs its native overworld battle-transition animation.
- Trainer battle music starts with the wipe through the normal battle path.
- `248` and `254` start the low-health alarm at transition time.
- `252` remains silent.
- After `battle.started`, the captured full-screen corruption replaces the
  visible battle while the real battle remains underneath.
- Recovery exits through `BattleState:finish()`, restoring map music and using
  the native battle-return fade.
- The old instability text message has been removed from these effects.


## v1.1.0-alpha6 — corrected crash graphics

- Replaces the cropped 248 corruption image with the later head-inclusive frame.
- Replaces the cropped 254 corruption image with the later head-inclusive frame.
- Keeps alpha5 native battle transition, battle music, alarm timing, and safe recovery unchanged.


## v1.1.0-alpha7 — raw graphics renderer

- Specials 248 and 254 no longer use captured LCD screenshots as overlays.
- The mod loads captured 8 KiB VRAM, 160-byte OAM, and LCD-register data.
- A Game Boy compositor reconstructs background/window tile maps, 2bpp tiles,
  DMG palettes, scrolling, sprite flips, sprite priority, and 8x16 sprites.
- The reconstructed states animate through the captured sequence frame by frame.
- Special 252 remains a true white failure because no battle graphics appear.
- The native battle-transition/music bridge from alpha6 remains intact.


## v1.1.0-alpha7.2 — composite trainer entrance

- The captured VRAM/window sequence remains the source of the battle scene.
- Raw OAM sprites are hidden during the reconstructed entrance.
- The complete final player-trainer sprite is extracted from the raw OAM
  difference and assembled as one transparent object.
- The entire trainer, including the head, slides into position together.
- The lingering captured glitch Pokémon sprite is removed.
- No static battle screenshot is used.


## v1.1.0-alpha7.3 — LÖVE ImageData hotfix

- Removes the unsupported `Image:newImageData()` call.
- The Game Boy frame renderer now returns both its GPU Image and original CPU ImageData.
- Composite trainer extraction uses that retained ImageData directly.
- Failure to create composite data now logs and skips the layer instead of crashing.


## v1.1.0-alpha8 — native battle-sprite architecture

- Specials `248` and `254` no longer use the custom GlitchEffectScreen for
  their visible trainer scene.
- The corrected captured trainer graphics are installed through Gen1Recomp's
  supported `player.sprite` hook as a normal player trainer back pic.
- BattleState performs the entire native trainer slide-in, grounding, palette,
  scaling and teardown.
- The bridge opponent uses a transparent native trainer pic, so no unrelated
  Youngster or lingering captured glitch Pokémon remains.
- Rendering-pipeline mods see the same engine-owned battle sprite instead of a
  flattened full-screen overlay.
- Special `252` remains the silent white-screen case.


## v1.1.0-alpha8.1 — native sprite placement correction

- Removed party-ball HUD pixels accidentally included in the player asset.
- Rebuilt the corrupted player trainer as a normal 56×56 back sprite.
- Bottom-left grounding now matches Gen1Recomp's native trainer placement.
- Restored the captured glitched opposing sprite as the bridge trainer image.
- Both sides now use native BattleState sprite placement and slide-in.


## v1.1.0-alpha8.2 — player back-sprite size correction

- The native `player.sprite` battle path expects a 32×32 back-sprite source.
- Alpha8.1 incorrectly supplied 56×56, which BattleState doubled to 112×112.
- The corrupted player trainer is now a properly grounded 32×32 source and
  should render at the intended 64×64 battle size.
- The opposing trainer remains a native 56×56 front pic.


## v1.1.0-alpha8.3 — crash audio and protected-save recovery

For Specials `248` and `254`:

1. The native battle presentation remains visible briefly.
2. Battle music and the low-health alarm stop on a looping held note.
3. The battle fades gradually to white.
4. The white screen holds for several seconds.
5. A two-page recovery message appears:

   `MEMORY CORRUPTION DETECTED!`

   `YOUR SAVE FILE WAS PROTECTED FROM DAMAGE.`

6. The held note stops and the battle exits through the normal safe teardown.

The tone is a mod-supplied generated square wave and does not alter the game
audio assets.


## v1.1.0-alpha8.4 — native intro animation hotfix

- The crash-recovery controller now advances the underlying battle's
  presentation clock with `BattleState:tickFx()`.
- Player and enemy sprites can complete their native intro slide while the
  transparent recovery controller is on top of the stack.
- Menus and combat logic remain paused.
- The stuck note, white fade, safety message, and teardown are unchanged.


## v1.1.0-beta1-jacred1 — authentic Jacred graphics

- Replaced the obsolete vertical-line Jacred placeholder.
- The new asset is extracted from the fully loaded upper-right 7×7 trainer
  tile block in the targeted Special-200 VRAM capture.
- Source frame: Jacred Explorer sequence 0149.
- Source screen region: `(96, 0)` through `(151, 55)`.
- The resulting image is an exact 56×56 native trainer front picture.
- White background pixels are transparent; all visible DMG shades are
  preserved exactly from the captured VRAM reconstruction.
- Crash framework behavior is unchanged from alpha8.4.


## v1.1.0-beta1-jacred2 — backwards corrupted player sprite

- Jacred keeps the authentic 56×56 VRAM-derived front picture from jacred1.
- The player's battle back sprite is replaced through the native
  `player.sprite` hook only while battling `TF_JACRED`.
- It reuses the proven 32×32 corrupted back sprite from the crash encounters.
- The Jacred-specific copy is mirrored horizontally to reproduce the
  backwards-facing appearance.
- BattleState still owns native slide-in, scaling, positioning, palette, and
  voxel-mod presentation.
- Specials 248 and 254 retain their existing non-mirrored corrupted back
  sprite.


## v1.1.0-beta1-jacred3 — Jacred victory warning

When Jacred is actually defeated, the mod now displays:

`JACRED ATTEMPTED TO CORRUPT YOUR SAVE FILE.`

`NO PERMANENT DAMAGE WAS FOUND.`

- The warning is victory-only.
- Running, losing, or any later intercepted crash path does not trigger it.
- The message is queued after native battle teardown, so map state and music
  recovery complete normally.
- Jacred's front sprite and reversed corrupted player back sprite are unchanged.


## v1.1.0-beta1-jacred4 — unstable Jacred names

Jacred's user-facing trainer name is regenerated before every battle.

Weighted outcomes:

- 35% generated garbage text
- 25% Pokémon name
- 15% blank
- 15% existing trainer-class name
- 10% `JACRED`

The garbage generator uses uppercase letters, digits, punctuation, multiplication
sign, and gender symbols to approximate the appearance of bytes decoded through
an invalid Generation I text pointer.

Names are limited to ten displayed characters. The internal trainer ID remains
`TF_JACRED`, so battle logic, native sprites, and the victory safety message are
not affected by the random display name.


## v1.1.0-beta1-jacred5 — safe POKéTRAINER Bag

Special `200` with Attack Modifier `5` or `6` opens a temporary ZZAZZ-style
corrupted Bag after the native Jacred intro.

- Five repeated `POKéTRAINER ×99` entries are displayed.
- Selecting any entry freezes the visible battle.
- Music hangs on the reusable stuck-note effect.
- Junk text appears before a fade to white.
- Recovery message:

  `POKéTRAINER DISCARDED.`

  `NO PERMANENT DAMAGE WAS FOUND.`

The fake Bag is not the player's real inventory. No item IDs, names, quantities,
or save-backed Bag structures are modified. Removing the temporary screen
eliminates every simulated item unconditionally.


## v1.1.0-beta1-jacred6 — hidden Poké Ball escape

The temporary ZZAZZ Bag now contains seventeen `POKéTRAINER ×99` entries and
a hidden `POKé BALL ×99` on row eighteen.

Selecting the hidden Poké Ball closes the fake Bag, consumes no real item,
performs no RAM or save-data write, ends Jacred's battle through native battle
teardown, and confirms that the battle ended safely.

The real Bag remains untouched in both the POKéTRAINER and Poké Ball paths.


## v1.1.0-beta1-jacred7 — discovery and message fixes

- The corrupted Bag no longer opens automatically.
- Attack Modifier `5` or `6` starts a normal Jacred battle.
- The simulated corrupted Bag appears only after the player chooses `ITEM`.
- Hidden Poké Ball confirmation is queued after native battle teardown.
- `POKéTRAINER DISCARDED.` and `NO PERMANENT DAMAGE WAS FOUND.` are separate
  manual pages and do not auto-scroll.
- All fake inventory entries remain temporary and are removed after recovery.


## v1.1.0-beta1-jacred8 — reliable hidden Poké Ball message

- Replaced the boolean deferred-message flag with a one-shot callback.
- The callback is armed before `battle:finish()`.
- It runs on `battle.ended` when available.
- A `world.resumed` fallback runs the same callback if the battle's `run`
  teardown does not emit the expected result event.
- The callback clears itself before displaying text, preventing duplicates.


## v1.1.0-beta1-jacred9 — native blocked-ball escape

Selecting the hidden `POKé BALL ×99` now performs the native trainer-battle
ball sequence:

1. `TOSS_ANIM`
2. Ball-toss sound
3. Block/thud animation
4. `The trainer blocked the BALL!`
5. `Don't be a thief!`
6. Immediate safe Jacred battle teardown
7. Manual confirmation pages:
   - `THE POKé BALL BROKE THROUGH THE CORRUPTION!`
   - `THE BATTLE ENDED SAFELY.`

The confirmation is pushed directly after `battle:finish()` and no longer
depends on deferred world or event callbacks.

The simulated Poké Ball never touches the real inventory.


## v1.1.0-beta1-jacred10 — early Trainer-Fly battle music

Trainer-Fly encounters now begin their battle theme the instant the
automatically forced Start menu closes.

The music starts before the overworld battle-transition wipe for:

- Normal glitch Trainers `201–247`
- Jacred and the ZZAZZ Bag variants
- Safe crash recreations
- Normal and glitch Pokémon resolved through Trainer-Fly

Trainer themes retain normal classification:

- ordinary Trainer music;
- Gym/Lance music;
- final Rival music.

The native `Overworld:pushBattle()` request remains in place. Because
`Music.play()` ignores a request for the song already playing, the later
transition does not restart the theme.


## v1.1.0-beta1-jacred11 — authentic corrupted Bag ordering

The simulated ZZAZZ Bag now uses this order:

1. Twelve `POKéTRAINER ×99` entries
2. One fake `CANCEL`
3. Five blank entries
4. One hidden `POKé BALL ×1`

The player must scroll past `CANCEL` and the blank rows to discover the ball.

- Fake `CANCEL` does not close the Bag.
- Blank rows are selectable but inert.
- The hidden Poké Ball has quantity one.
- None of these simulated entries exist in the real inventory.


## v1.1.0-beta1-jacred13 — restored trigger timing options

The Trainer-Fly options menu again includes `TIMING MODE`:

- `STRICT` — one-frame Start window
- `RELAXED` — three-frame Start window
- `EASY` — five-frame Start window

The native input latch remains authoritative. The expanded modes only accept a
recent Start press when the landing frame consumes the exact input edge.

This revision is built from jacred11. It retains the early battle-music handoff,
Jacred graphics and naming, corrupted Bag, blocked-ball animation, fake CANCEL
and blank rows, hidden single Poké Ball, and all save-safety protections.


## v1.1.0-beta1-jacred14 — repaired ZZAZZ ITEM interception

The fake corrupted Bag no longer depends on comparing Lua battle-object
identity.

A single explicit encounter-state controller now records:

- encounter kind;
- Jacred variant;
- whether the battle is active;
- whether the fake Bag is enabled;
- the current battle reference for cleanup only.

The ITEM command checks this state plus Jacred's stable internal trainer ID.
Special `200` with Attack Modifier `5` or `6` should therefore open the
simulated POKéTRAINER Bag instead of the player's real inventory.

Early battle music, timing modes, Jacred graphics/names, blocked-ball behavior,
fake CANCEL/blank rows, and save-safety protections remain unchanged.


## v1.1.0-beta1-jacred15 — ITEM hook installation fix

The Jacred ITEM interceptor is now installed every time this version of the mod
loads. The former one-time class flag could leave an older wrapper active and
silently skip the current implementation.

The log now confirms installation with:

`Installed Jacred ITEM interception patch v1.1.0-beta1-jacred15`

Choosing ITEM also logs a `Jacred ITEM check:` line.

The Special-value editor is widened from five to six tiles and shifted left one
tile, giving three-digit values proper right-side padding.


## v1.1.0-beta1-jacred16-diagnostic

Visible in-game diagnostics replace invisible log-file instructions.

At startup:

`JACRED BAG HOOK / PATCH 16 LOADED`

When ITEM is selected:

- `ITEM HOOK: PASS / OPENING FAKE BAG`, or
- `ITEM HOOK: FALLBACK / OPENING REAL BAG`

The banner closes with A/B after a brief delay or automatically after about
2.5 seconds. The appropriate Bag then opens.

The widened three-digit Special editor remains included.


## v1.1.0-beta1-jacred17-diagnostic — safe hidden-ball teardown

The hidden Poké Ball no longer calls `battle:finish()` from inside the native
battle action queue.

After the blocked-ball messages complete, a temporary transition controller
waits until the action callback has returned. It then invokes native teardown
from a normal screen update. The two safety messages are queued only after the
matching `battle.ended` event confirms that teardown is complete.

This specifically addresses the hard desktop crash after:

`Don't be a thief!`

The visible ITEM-hook diagnostics and widened Special-value editor remain.


## v1.1.0-beta1-jacred18-diagnostic — reliable ending messages

The hidden Poké Ball confirmation no longer depends on the overworld script
queue. After the matching `battle.ended` event, a dedicated controller waits
three update frames for the overworld stack to settle, then opens two native
TextBox pages directly.

Expected pages:

1. `THE POKé BALL BROKE / THROUGH THE CORRUPTION!`
2. `THE BATTLE ENDED / SAFELY.`

The safe deferred battle teardown from jacred17 is retained.


## v1.1.0-beta1-jacred19-diagnostic — overworld-gated messages

The hidden Poké Ball ending messages are no longer pushed during
`battle.ended`. Native teardown can continue after that event and discard new
screens.

The message now remains pending until `Overworld.update` confirms:

- the overworld is the top screen;
- no map transition is active;
- no world script is running.

Only then are the two native text pages displayed.


## v1.1.0-beta1-jacred20-diagnostic — Lua scope repair

The overworld update closure in patches 17–19 was created before
`pendingJacredBallMessage` and `pendingJacredBallExitBattle` were declared.
Lua therefore resolved those names differently from the later battle-state
locals. The delivery condition could never observe the pending message.

Patch 20 forward-declares both variables before the overworld wrapper and
removes the later shadowing declarations.

The startup banner now also waits for the actual overworld to be topmost and
idle rather than appearing during `game.ready`.


## v1.1.0-beta1-jacred21-diagnostic — remove battle identity gate

Patch 20 proved that the overworld update hook and startup delivery now work.

The remaining hidden-ball message was still blocked by a comparison between
the battle object saved during forced exit and the object exposed by the
`battle.ended` event. That identity is not reliable in this path.

Patch 21 treats the safe return to a topmost, idle overworld as the teardown
confirmation. Once the hidden-ball path sets its durable pending flag, the
message is delivered without requiring any battle-object match.


## v1.1.0-beta1-jacred22-diagnostic — final lexical-scope repair

Patch 20 moved the pending-message declarations above `Overworld.update`, but
`JacredSafeExitScreen` was defined even earlier in the file. Its assignments
therefore still targeted globals, while the overworld watched locals.

Patch 22 moves the shared declarations above:

- `JacredPostBattleMessageScreen`;
- `JacredSafeExitScreen`;
- `Overworld.update`;
- all battle event handlers.

Every read and write now closes over the exact same local variables.


## v1.1.0-beta1-jacred23-quickwarp

- Adds persistent SET WARP POINT and CLEAR WARP POINT debug actions.
- Stores map, cell X/Y, and facing in `trainer_fly/quick_warp_v1.dat`.
- Does not modify the Pokémon save.
- When a point exists, Start opens GAME MENU / WARP POINT during ordinary
  overworld play.
- Trainer-Fly's interrupted-trainer Start path bypasses the Quick Warp gateway.
- Hidden-ball ending text waits for A/B release before appearing.
- Startup diagnostics use a smaller two-line box.


## v1.1.0-beta1-jacred24-quickwarp

The diagnostic screen now splits newline-delimited messages and draws each line
separately. Gen1Recomp's `Font.draw()` does not perform newline layout itself,
which caused the startup message to run through the right border.

Expected startup layout:

    JACRED BAG HOOK
    PATCH 24 LOADED


## v1.1.0-beta1-jacred25-quickwarp-hotkey

Adds a direct emergency Quick Warp control:

    Hold SELECT + press START

The hotkey is evaluated before Trainer-Fly's normal Start suppression, so it
works while the escaped-trainer glitch state is active. It immediately uses the
saved persistent destination without opening the Start menu.

Safety gates still require:

- a valid saved Quick Warp point;
- the overworld to be active;
- no map transition;
- no running world script.

Normal Start behavior and the ordinary GAME MENU / WARP POINT gateway remain
unchanged.


## v1.1.0-beta1-jacred26-quickwarp-fix

### Warp-point capture

`SET WARP POINT` no longer requires the overworld to be the top screen. Since
the action is selected from the mod-options screen, that requirement made every
valid attempt fail.

The action now records the underlying active overworld when:

- the map and player exist;
- no map transition is active;
- no world script is running;
- no Trainer-Fly/Jacred battle is active.

### Startup diagnostic

The temporary diagnostic is now drawn in a wider box at the top of the screen.
Each line and the continue prompt are centered independently, keeping it clear
of route/area announcement overlays at the bottom.


## v1.1.0-beta1-jacred27-linebreak-fix

The prior diagnostic splitter used `[^\\n]+`, which treated backslash and
the letter `n` as excluded characters instead of matching an actual newline.

Patch 27 appends a real newline and parses each line with `(.-)\n`, so the
startup and ITEM-hook diagnostics are laid out as separate lines.


## v1.1.0-beta1-jacred28-warp-capture-fix

`activeWorld` was previously assigned only after Trainer-Fly or Teleport had
already started. During ordinary play it remained nil, so SET WARP POINT always
failed.

Patch 28 records the current world on every overworld update. SET WARP POINT
then validates only the live map ID and numeric player cell coordinates. This
is safe because the action only reads position data and writes the mod-local
Quick Warp file.


## v1.1.0-beta1-jacred30-native-warp-menu

### Visible saved-point state

After SET WARP POINT succeeds, its option now displays `ON`. CLEAR WARP POINT
returns it to `OFF`. Loading a persistent point at startup also synchronizes the
display automatically.

### Start-menu gateway

Normal Start and SELECT+START detection have moved from `Overworld.handleInput`
to the beginning of `Overworld.update`, before vanilla input consumption.

When a point exists:

- Start opens `GAME MENU / WARP POINT`;
- SELECT+START performs the saved warp immediately;
- Trainer-Fly's escaped-trainer Start path remains reserved.


## Jacred30 Quick Warp changes

- Removes the temporary `GAME MENU / WARP POINT` gateway.
- Adds `WARP POINT` directly to the native Start menu before `QUIT`.
- Shows the entry only while a valid persistent point exists.
- Keeps `SELECT + START` as the emergency direct-warp shortcut.
- Converts the SET/CLEAR rows to action-style controls with live `READY` / `EMPTY` status.


## Jacred30.8 Quick Warp hotkey

The emergency Quick Warp shortcut is now **hold A, then press B**.
START and SELECT are no longer intercepted, allowing the native Start menu
and other mods' SELECT-based field-action menus to function normally.
A or B by itself does not invoke Quick Warp. Simultaneous A+B does not count;
A must already be held before the fresh B press.


## v1.1.0-beta1-jacred30.10-pokeball-page-split

- Split the first hidden Poké Ball recovery sentence into two native-sized pages.
- Prevents TextBox internal auto-scroll from hiding the beginning of the corruption message.
- Preserves the clean button-release pause between every page.


## Glitch City Visual Probe

This test build keeps the proven hidden-Poké-Ball battle ending and delayed overworld handoff. After the two overworld corruption-warning pages are dismissed, a temporary five-second visual corruption overlay appears while normal movement continues. The probe does not modify map blocks, collision, music, saving, or warp behavior.


## Glitch City 4 — Runtime Map Corruption Probe

This build removes the prior fullscreen interference overlay. After the qualifying ZZAZZ hidden Poké Ball exit and overworld warning, the mod snapshots the live source map's block grid, rearranges real blocks already used by that map, rebuilds the map renderer, and leaves the result active for eight seconds. Both terrain and collision are affected. The immediate area around the player is preserved to prevent an instant trap.

The original block grid is restored automatically when the timer expires or when the player changes maps. No map edits are written to the Pokémon save.


## Glitch City 5 Test Additions

- Adds a built-in Mods-menu action: `START TEST BATTLE`.
- Uses the currently selected `SPECIAL VALUE` and `ATTACK MOD`.
- After activating it, close the Mods screen; the selected Trainer-Fly result begins as soon as the overworld is safely active.
- This action does not require Trainer-Fly, Teleport, or an intermediary battle. It is a development shortcut only.
- Glitch City terrain corruption is intentionally stronger in this probe, with larger repeated and displaced map-block regions.


## Persistent G1GPP Debug Logger

The mod includes its own persistent diagnostic logger because Gen1Recomp may not
surface useful runtime logs to the player. The logger writes to the mod-local
LÖVE save directory:

```text
pokemon-love2d/trainer_fly/g1gpp_debug.log
```

On Windows this is normally under:

```text
C:\Users\<name>\AppData\Roaming\pokemon-love2d\trainer_fly\g1gpp_debug.log
```

Available development actions:

- `WRITE DEBUG SNAPSHOT` records the current overworld, map, player, movement,
  transition, script, battle, and Glitch City state.
- `CLEAR DEBUG LOG` resets the file before a clean reproduction test.

### Logging contract for new work

Every new feature or meaningful state transition must add diagnostic entries for
its complete lifecycle where practical:

1. request/input received;
2. preconditions and captured inputs;
3. state before mutation;
4. action attempted and arguments used;
5. success/failure result, including caught errors;
6. state after mutation;
7. cleanup, cancellation, timeout, or recovery path.

Save-safety features must log every blocked write and the reason it was blocked.
Map, warp, battle, audio, renderer, asset-transform, collision, and recovery work
must log enough identifiers and before/after values to reproduce failures without
guessing. Large binary data and sensitive save contents must not be dumped.

When a feature appears not to work, obtain a clean reproduction by clearing the
log, reproducing once, writing a snapshot if useful, and preserving
`g1gpp_debug.log` with the test build/version and exact test steps.


## 12.8.2 Mod Manager nil-row hotfix

The Mod Manager can return `nil` for some schema passes. G1GPP now checks the
return type before iterating option rows, preserves the engine result, and logs
`MOD MENU ROWS UNAVAILABLE` with schema/mod context instead of crashing.


## Debug session markers

The persistent `g1gpp_debug.log` now records explicit `SESSION START`, `GAME LOADED`, and `SESSION END` entries. A small `g1gpp_session_open.txt` marker is removed on a clean quit. If the game crashes or is force-closed, the next launch records `PREVIOUS SESSION UNCLEAN END`, making session boundaries and abnormal termination visible in one continuing log.


## Glitch City 12.10 experimental reverse-audio probe

This build replaces the 12.9 pitch-only treatment with an experimental chunkwise reverse path. When Glitch City activates, the mod pauses the ordinary map source, clones the current streaming source, and replays approximately 100 ms slices while seeking backward through the track. This reverses the order of short musical segments, but each individual segment still plays forward because LÖVE Source objects do not expose decoded PCM samples. It is therefore a practical reverse approximation, not sample-perfect PCM reversal.

The logger records AUDIO REVERSE START REQUEST, AUDIO REVERSE STARTED/FAILED, periodic AUDIO REVERSE PROGRESS, AUDIO REVERSE WRAPPED, per-chunk failures, and normal AUDIO RESTORED cleanup. The original map theme is restarted during Glitch City recovery.


## Glitch City 12.11 exclusive reverse-audio probe

This build keeps the descending reverse-chunk experiment but continuously mutes and pauses the engine-managed main and loop music sources while Glitch City is active. Only the mod-owned reverse clone should be audible. The logger records `AUDIO EXCLUSIVE MUTE ENFORCED` while the guard is active, then restores normal map music during recovery.


## Glitch City 12.13 recovery presentation

- Reverse-chunk audio now runs at pitch 0.94.
- At timer expiry, the corrupted fragment hangs briefly and sags in pitch.
- The screen fades to white while the corrupted audio fades away.
- Map restoration and the return-to-origin warp occur behind full white.
- The recovery message is displayed over white.
- Normal map music and the clean overworld fade back in together.


## Glitch City 12.13.2 recovery presentation probe

- Reverse-chunk playback pitch is now 0.82 for a more obviously corrupted sound.
- The ending uses a fixed-fragment audio hang at pitch 0.68 for roughly 0.6 seconds rather than a rapid pitch sweep.
- The white recovery field resets the graphics transform, removes scissor clipping, and fills the current render-target dimensions so camera transforms cannot leave overworld edges visible.
- Same-map music resume behavior from 12.13.1 remains in place.


## Glitch City 12.13.5 Jacred white-render-path correction

- User testing showed that the 12.13.2 fullscreen attempt still left visible strips of the actual overworld around the recovery field.
- The successful Jacred recovery series did not reset the graphics transform or query the physical render-target size. It drew a `160 x 144` white rectangle while preserving the engine's active logical-canvas scaling transform.
- 12.13.5 restores that exact proven rendering path for Glitch City recovery.
- The deeper `0.82` Glitch City pitch, fixed-fragment ending hang, same-map music resume fix, origin restoration, and white recovery sequence remain unchanged.


## 12.13.5 final-present white overlay

Recovery white is also drawn immediately before `love.graphics.present()` at physical window dimensions. This places it above voxel/post-processing renderer output while preserving the logical-canvas recovery overlay as a fallback.


## 12.13.5 recovery text visibility fix

During the full-white recovery message, the recovery screen becomes opaque and the final-present physical white overlay is temporarily disabled. This keeps the overworld from drawing underneath while allowing the normal recovery TextBox screens to render visibly above the white field. The physical overlay resumes for the fade back.


## Glitch City 12.13.6 — white margins and deeper pitch

- Glitch City reverse-order music pitch lowered from 0.82 to 0.50.
- Ending fixed-fragment hang pitch lowered from 0.68 to 0.45.
- During recovery messages, the final-present hook now fills only the physical pixels outside the transformed 160x144 logical viewport. This preserves visible TextBox pixels while eliminating the black widescreen/letterbox background.
- Route/area confinement remains under active development. The existing transition fallback restores the origin if a warp escapes; a proactive border/warp collision pass is planned rather than guessed without map-warp metadata.


## Glitch City 12.13.7 — oversized white field beneath recovery text

- Runtime testing of 12.13.6 showed the viewport-derived final-present margin mask was unreliable: it left a black L-shaped area and still covered the recovery TextBox.
- During recovery-message pages, the final-present overlay is now disabled entirely.
- The recovery screen instead draws a deliberately oversized logical white rectangle (`-4096,-4096` through `8192x8192`) before the TextBox screens draw.
- This keeps every physical/widescreen/overscan edge white while preserving the TextBox above the white field.
- Full final-present white remains active during fade-in and fade-out, where no TextBox needs to be visible.
- Glitch City music remains at pitch `0.50`; the fixed-fragment ending hang remains at pitch `0.45`.


## Glitch City 12.13.8 — corrupted-audio hard stop

- Stops and zeroes every known mod-owned corrupted/reverse source as soon as full white is reached, before the recovery text opens.
- Repeats the hard stop when the final recovery page closes, before the clean overworld fade begins.
- Adds `RECOVERY CORRUPTED AUDIO HARD STOP` diagnostics with the reason and number of unique sources stopped.
- This specifically addresses corrupted music remaining audible for several seconds after the recovery textbox disappeared.


## 12.13.9 test notes
- Temporary Glitch City duration: 15 seconds (900 frames). Restore to 30 seconds (1800 frames) for the final release after remaining issues are solved.
- Removed the post-recovery blanket music `play()` calls; map music is restored once and only engine-playing sources are faded up.
- Removed the non-Jacred ITEM diagnostic screen and noisy Jacred/ZZAZZ interception messages from normal gameplay.


### 12.13.10 test build
- Recovery message keeps the logical TextBox visible while a final-present margins pass fills only the physical pixels outside the centered 160x144 integer-scaled viewport.
- Post-recovery music watches the restored main source and starts only the designated loop source after the main source actually stops.
- Glitch City remains temporarily shortened to 15 seconds for iteration; restore to 30 seconds for final release.


## 1.1.0-beta1-glitchcity12.13.13-native-letterbox-music

Source-informed recovery test based on Gen1Recomp dev commit `f0ed2efe072a40a73f102a3f8d709d20d5d30b31`.

- Reverts the unsafe 12.13.12 final-present Canvas replay system.
- Removes clear/present interception and guessed viewport calculations.
- Uses the official `render.letterbox` hook, called by `Renderer:endFrame` after the physical surround fill and before normal world/UI composition.
- Paints the actual runtime drawable white at the recovery alpha; the normal game canvas and TextBoxes remain above it.
- Calls `Music.restoreMap(data)` only through the established recovery path.
- Does not manually play, stop, seek, or swap the restored main/loop sources.
- Continuously mutes whichever engine-managed sources are current while recovery text is open, then fades those current sources during fade-back. `Music.update(data)` owns intro-to-loop chaining.
- Adds `RECOVERY LETTERBOX WHITE` and `RECOVERY MUSIC NATIVE LIFECYCLE COMPLETE` markers.
- Glitch City remains temporarily 15 seconds; restore to 30 seconds for final release.


## 1.1.0-beta1-glitchcity12.13.14-physical-containment

Source-informed physical boundary containment based on the validated 12.13.13 recovery build.

- Snapshots the live map collision lookup, door/warp tile sets, warp index, and route-connection table when Glitch City activates.
- Disables every ordinary warp and route connection while retaining free movement through non-exit cells.
- Treats warp cells and every map edge as ordinary solid boundaries before movement begins; no coordinate clamping, message, recovery trigger, or pushback is used.
- Suppresses step-triggered events and scripts, scripted warps, ladders, caves, holes, doors, trainer engagements, encounters, interactions, and save writes throughout the corrupted state.
- Restores the exact captured collision, warp, and connection references before the clean map blocks and origin are recovered.
- Adds persistent `CONTAINMENT INSTALLED`, `CONTAINMENT EXIT BLOCKED`, and `CONTAINMENT RESTORED` log markers.
- Retains the validated native letterbox/music recovery and temporary 15-second duration.


## 1.1.0-beta1-glitchcity12.13.15-final-duration

- Based directly on the runtime-validated 12.13.14 physical-containment build.
- Changes only the Glitch City duration from the temporary 900 frames (about 15 seconds) to the final 1800 frames (about 30 seconds), plus version/package metadata.
- Preserves containment, save and script guards, recovery presentation, exact state restoration, persistent logging, and native music lifecycle without behavioral changes.
## v1.1.0-beta1-missingno12.13.29 — MissingNo. presentation modes

`MISSINGNO. ENTRY` now offers two presentation modes. `LORE-FRIENDLY` is the
default and shows the original Red/Blue-style blank No.000 record with Rhydon's
cry, without adding a category, measurements, or authored description.
`ENHANCED` retains G1GPP's optional `UNKNOWN`, zero-measurement record and the
text `NO DATA EXISTS. / ITS FORM CHANGES / EACH TIME IT IS / OBSERVED.`

Both modes are presentation-only. MissingNo. remains hidden from the ordinary
001-151 Pokédex list, its internal schema-safe registration is unchanged, and
no Pokédex, party, Hall of Fame, or save state is rewritten. This build also
passes the current upstream `DexEntryMenu.new` completion callback through the
mod wrapper so scripted callers continue normally.
## v1.1.0-beta1-missingno12.13.30 — Master Ball debug action

The Mods/debug screen now includes `ADD MASTER BALL`. Each activation adds
exactly one Master Ball to the live save through Gen1Recomp's canonical
`Bag.add` API. The value displayed beside the action is the current quantity.
If the Bag has no free slot, the action leaves inventory unchanged and records
the failure in `g1gpp_debug.log`. Request, prior quantity, result, new quantity,
slot count, and capacity are logged persistently.
## v1.1.0-beta1-missingno12.13.31 — Warp Anywhere debug catalog

`WARP ANYWHERE` opens a scrollable, wrapping destination list derived from the
actual Red/Blue/Yellow map warp metadata. It includes every Pokémon Center
exterior, Indigo Plateau, all eight Gym entrances, and major testing landmarks
such as Bill's House, the S.S. Anne, Oak's Lab, Pokémon Tower, Silph Co., Safari
Zone, Power Plant, Pokémon Mansion, Cinnabar Lab, Cerulean Cave, Victory Road,
Mt. Moon, Rock Tunnel, Seafoam Islands, and Diglett's Cave.

Press A on a destination to queue it and return to the Mods screen. The warp
does not execute until every menu is closed and the overworld is idle. Landing
points sit one tile outside doors rather than on active warp cells. Missing
edition-specific maps are filtered out, and selection, execution, completion,
and failure states are written to `g1gpp_debug.log`.
## v1.1.0-beta1-missingno12.13.32 — Enhanced No.000 Pokédex index

When `MISSINGNO. ENTRY` is set to `ENHANCED`, owning a preserved MissingNo. now
adds a selectable `000 MISSINGNO.` row at the beginning of the ordinary Pokédex
screen. Its DATA command reopens the authored Enhanced entry. The row uses the
owned Poké Ball marker and the safe species ID, while the schema-only internal
Dex value remains hidden.

`LORE-FRIENDLY` remains unchanged: MissingNo.'s No.000 page appears through the
original-style capture path but is not retained in the selectable 001-151 list.
Changing modes does not alter ownership, species, party, Hall of Fame, or save
records; it only controls whether the additional No.000 list row is presented.

## 1.1.0-beta1-missingno12.13.44-runtime-trainer-nibble-swap

Research probe for MissingNo. Trainer-back corruption.

- Promotes the user-validated 12.13.43 enemy/front and player-Pokemon runtime transforms unchanged.
- MissingNo. inversion no longer substitutes `assets/native_glitch/corrupted_trainer_back.png`.
- The normal Gen1Recomp runtime Trainer back picture is preserved and transformed at draw time.
- Transform is derived directly from pokered `InterlaceMergeSpriteBuffers`: when `wSpriteFlipped` is non-zero, every 2bpp source byte receives `swap [hl]`, exchanging pixels 0-3 with pixels 4-7 in every 8-pixel row while preserving order within each 4-pixel half.
- Jacred and crash-recreation paths continue using their existing dedicated corrupted Trainer asset; this experiment changes MissingNo. inversion only.
- Expected debug markers: `INVERTED TRAINER SOURCE PRESERVED` and `INVERTED SPRITE RENDERED ... role=trainer_nibble_swap`.

This build is a runtime research candidate. The remaining fidelity question is whether Gen1Recomp's flattened Trainer-back rendering needs an additional intro-only head/body compositing hook to reproduce the original Game Boy's 7x3 OAM head transparency over the BG body/enemy picture.


## 1.1.0-beta1-missingno12.13.45-trainer-reversed-column-nibble-swap

- Corrects the 12.13.44 Trainer-facing regression observed in runtime testing.
- MissingNo. inverted Trainer presentation still derives from Gen1Recomp's native runtime Red back picture; the dedicated corrupted Trainer PNG is not used for this effect.
- Reverses the 8-pixel Trainer tile-column placement so the affected Trainer reads as facing left, while retaining Red/Blue's measured per-byte 4-pixel nibble swap inside each tile row.
- Enemy initial mirror, post-attack enemy tile corruption, player-Pokemon back corruption, and ordinary-stat recovery are unchanged from the validated 12.13.43 behavior.


## 1.1.0-beta1-missingno12.13.46-trainer-oam-bg-handoff-probe

Trainer-only implementation probe based on the completed Red/Blue mGBA evidence.

- Keeps the validated 12.13.43 enemy and player-Pokémon corruption behavior unchanged.
- BG Trainer remains the 12.13.45 reversed-column + authentic nibble-swap rendering.
- During the native Gen1Recomp intro slide only, a separate top-three-hardware-row head overlay is rendered from nibble-swapped data in normal column order, matching the original 7x3 OAM-head construction.
- The overlay uses Gen1Recomp's own `introSlide` displacement; there is no custom frame timer.
- When `introSlide` reaches zero, the overlay stops drawing and the BG head underneath becomes visible. This models the observed original OAM hide -> BG reveal rather than inventing an endpoint X-flip.
- This probe deliberately does not hard-code the Red/Blue moving-head color. The newly established evidence shows that different OBJ/BG head color is ordinary base-game intro behavior, not a MissingNo-specific effect.

Expected inverted visual test: while sliding, corrupted Trainer body should face left while the temporary head/hat reads right-facing; at the settled position the temporary head disappears and the visible BG head reads left-facing.

## 1.1.0-beta1-missingno12.13.47-trainer-oam-7x3-geometry

- Based directly on the 12.13.46 Trainer OAM/BG handoff probe.
- Corrects the temporary inverted Trainer head to the original hardware OAM
  geometry: 7 columns x 3 rows = 56x24 final pixels.
- Gen1Recomp's Trainer-back source is drawn at 2x, so the overlay now crops the
  equivalent 28x12 source-space region instead of drawing the full source width.
- 12.13.46 had already limited the overlay to 24 final pixels tall, but still
  used the full source width; this made the moving head visually too large/heavy.
- Keeps the native `introSlide` lifecycle and the existing corrupted BG Trainer
  path unchanged.
- Adds `INVERTED TRAINER OAM GEOMETRY` to the persistent debug log with source,
  crop, scale, and final dimensions.
- Corrects the internal `BUILD_VERSION` marker so `SESSION START` /
  `MOD INITIALIZED` diagnostics identify 12.13.47 rather than the older 12.13.43
  sprite baseline.

## 1.1.0-beta1-missingno12.13.48-authentic-trainer-postscale-buffer

- Replaces the 12.13.45-12.13.47 Trainer approximation with the original
  Red/Blue transform ordering.
- Original behavior is modeled as:
  32x32 Trainer source -> ScaleSpriteByTwo using only 28x28 -> 56x56 7x7 tile
  buffer -> wSpriteFlipped nibble swap -> BG body + temporary 7x3 OAM head.
- Because Gen1Recomp applies the normal Trainer 2x nearest-neighbor scale at
  draw time, the exact source-space equivalent is a 2-pixel-half swap inside
  each 4-pixel source block over the effective 28x28 area.
- Removes the manual reversed-8px-column assumption from the active Trainer
  path. No explicit Trainer mirror is added.
- BG body and moving head now share the same corrupted buffer.
- The moving head remains the hardware-equivalent 7x3 / 56x24 final region and
  uses native introSlide timing.
- Adds `INVERTED TRAINER POST-SCALE BUFFER READY` and identifies the OAM
  geometry log as `pipeline=post_scale_equivalent`.
- Enemy-front and player-Pokemon back corruption paths remain unchanged.
- Runtime validation is still required before promotion.

## 1.1.0-beta1-missingno12.13.49-trainer-bg-reverse-oam-21tile

- Based on 12.13.48 after runtime testing showed the Trainer body no longer
  read left-facing and the moving head still looked structurally wrong.
- Restores the BG Trainer's reversed 7-column placement, but keeps the newer
  authentic post-ScaleSpriteByTwo-equivalent nibble corruption.
- BG body now uses `trainer_postscale_bg_reverse`:
  post-scale-equivalent corruption + reversed 4px source columns over the
  effective 28x28 source area.
- Moving head still comes from the same corrupted data but is now explicitly
  built as a 21-tile / 7x3 OAM group in ordinary column order instead of being
  treated as a plain cropped overlay source.
- OAM geometry remains 56x24 final pixels at the normal 2x battle scale.
- Adds `INVERTED TRAINER OAM TILE MAP` to the log.
- Enemy-front and player-Pokemon-back corruption paths remain unchanged.
- Runtime validation is still required before promotion.

## 1.1.0-beta1-missingno12.13.50-dev-dual-log-mirror

- Development-instrumentation build based on 12.13.49; no Trainer graphics
  behavior is intentionally changed in this build.
- The authoritative debug log remains the normal LÖVE/AppData file:
  `pokemon-love2d/trainer_fly/g1gpp_debug.log`.
- Debug builds additionally mirror the log to the workstation's Google Drive:
  `G:\My Drive\Glitch Project\Project Documentation\g1gpp_debug.log`.
- At startup, the Drive copy is rebuilt from the full authoritative AppData log,
  then each new log line is appended to both files.
- `CLEAR DEBUG LOG` clears both copies before writing the new `LOG CLEARED` line.
- Drive writes are best-effort: a missing/unmounted G: drive never affects the
  game or primary log.
- Session startup records `DEBUG DRIVE MIRROR ACTIVE` or
  `DEBUG DRIVE MIRROR UNAVAILABLE` with the target path and error.
- **Public releases must remove/disable the external Drive mirror.** It is a
  development-only diagnostic feature and is not part of G1GPP's public
  runtime behavior or configuration contract.
