# Azeroth Cursor V2 - development plan

The stable v1.2.0 release and main branch are not modified by this work.

## Working rules
- All V2 work lands on `feat/v2-cursor-studio`.
- No release or merge without maintainer approval after in-game testing.
- Keep native WoW 1.12 / Lua 5.0 compatibility and opt-in effects.
- Preserve SavedVariables on upgrades. Do not silently reset existing preferences.
- Each playable test build must include an installable ZIP and a short test checklist.

## Lot 1 - reliability
- [x] `/azcursor off` disables marker and class icon together.
- [x] Locate cursor no longer persists marker activation.
- [x] Avoid reseeding Lua's global random generator.
- [ ] Run Lua 5.0 tests and check the native game.
- [ ] Verify minimap and color picker interactions.

## Lot 2 - UI
- [ ] Separate style selection, appearance and effects.
- [ ] Clearly distinguish toggles from actions.
- [ ] Improve preview size and legibility.
- [ ] Retain French and English translations.

## Lot 3 - visuals
- [ ] New distinct ring/crosshair styles.
- [ ] Contrast-safe color defaults.
- [ ] Optimize static texture updates.

## Lot 4 - profiles
- [ ] Save, rename, duplicate and delete.
- [ ] Safe import/export with bounded validation.
- [ ] Versioned migration.

## Lot 5 - contextual effects
- [ ] Research supported game events before implementing automation.
- [ ] Optional animation with low-overhead fallback.

## Lot 6 - release
- [ ] Regression tests, in-game recipe and screenshots.
- [ ] Installable ZIP with SHA-256.
- [ ] Complete cumulative English changelog and Discord announcement.

## Known limitations
The addon draws an overlay, not a replacement native cursor. Window focus and click detection must be verified against the actual game API before being promised.
