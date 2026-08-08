# G1GPP Differences from Base Gen1Recomp

This document is maintained throughout development because Gen1Recomp publishing policy requires release-facing differences to be documented explicitly.

## Project intent

G1GPP preserves reproducible Generation I Pokémon glitches in Gen1Recomp rather than modernizing or correcting them. Where original behavior would risk real save corruption or unsafe persistent state, G1GPP reproduces the visible/gameplay consequence in a sandboxed or simulated form while protecting the actual player save.

## Implemented / established areas

- Trainer-Fly / long-range trainer glitch preservation baseline.
- Special 200 Jacred/ZZAZZ behavior and related controlled glitch-state presentation.
- Quick Warp support used by glitch-reproduction workflows.
- Glitch City preservation behavior.
- MissingNo encounter/presentation work, including Gen I-specific corrupted sprite behavior under active research.
- Save-safety handling for destructive or volatile original glitch consequences.

## Intentional safety differences

Some original Gen I glitches can corrupt or destroy persistent save data. Public G1GPP builds must not intentionally corrupt the real Gen1Recomp save. Equivalent consequences are simulated, sandboxed, or made volatile where necessary.

## Development-only differences

Private development builds may contain extra logging, probes, capture hooks, or research instrumentation. These are not release features and must be removed or disabled before public packaging. The current development logger includes an optional hard-coded Google Drive mirror and is explicitly development-only.

## Asset handling

Private research builds historically used captured/generated assets while behavior was being reverse-engineered. Those assets are not considered public-distribution-ready. Public source/release packaging must use original project-created content or permitted transforms/recipes based on the player's Gen1Recomp cache as required by upstream publishing policy.

## Release status

This file is not yet a complete end-user changelog. It must be reviewed and expanded before the first public beta/release candidate.
