# G1GPP Differences from Base Gen1Recomp

This document is maintained throughout development because Gen1Recomp publishing policy requires release-facing differences to be documented explicitly.

## Project intent

G1GPP preserves reproducible Generation I Pokémon glitches in Gen1Recomp rather than modernizing or correcting them. Where original behavior would risk real save corruption or unsafe persistent state, G1GPP reproduces the visible/gameplay consequence in a sandboxed or simulated form while protecting the actual player save.

## Implemented / established areas

- Trainer-Fly / long-range trainer glitch preservation baseline.
- Special 200 Jacred/ZZAZZ behavior and related controlled glitch-state presentation.
- Quick Warp support used by glitch-reproduction workflows.
- Glitch City preservation behavior, including the Safari Zone save/reset
  route for Red/Blue. The remaining Safari counter follows the player outside,
  the PA recall resolves the destination map's real fifth warp, and an outdoor
  map without one enters G1GPP's bounded, recoverable Glitch City recreation.
  Blue has been live-tested across missing/present fifth warps, indoor expiry,
  both post-reload prompt choices, persistence, recovery, and debug-HUD cleanup;
  Red shares the accepted path. Yellow-specific validation remains pending.
- MissingNo encounter/presentation work, including Gen I-specific corrupted sprite behavior under active research.
- Save-safety handling for destructive or volatile original glitch consequences.

## Intentional safety differences

Some original Gen I glitches can corrupt or destroy persistent save data. Public G1GPP builds must not intentionally corrupt the real Gen1Recomp save. Equivalent consequences are simulated, sandboxed, or made volatile where necessary.

## Development-only differences

Private development builds may contain extra logging, probes, capture hooks, or
research instrumentation. The public builder omits their sentinel, menu
modules, launch helpers, and user-specific mirror setup. No G1GPP debug entry or
test shortcut is exposed by the public package.

## Asset handling

Private research builds historically used captured/generated assets while behavior was being reverse-engineered. Those assets are not considered public-distribution-ready. Public source/release packaging must use original project-created content or permitted transforms/recipes based on the player's Gen1Recomp cache as required by upstream publishing policy.

## Release status

The first public candidate is `v1.0.0-beta`: Red/Blue confirmed, Yellow
provisional. Gold/Silver/Crystal are declared only so one imported Gen II cache
can lawfully bootstrap Marill art. The authoritative release-readiness
checklist and official Mod Index workflow are documented in
`PUBLIC_RELEASE.md`.
