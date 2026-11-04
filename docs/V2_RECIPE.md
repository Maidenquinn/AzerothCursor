# Azeroth Cursor 2.0.0-beta.1 - in-game recipe

This is a **development build**, not the public stable release. Back up `WTF/Account/<account>/SavedVariables/AzerothCursor.lua` before testing.

## Installation
1. Exit the game.
2. Remove or rename the old `Interface/AddOns/AzerothCursor` directory (avoid mixed Lua versions).
3. Extract the ZIP so that `Interface/AddOns/AzerothCursor/AzerothCursor.toc` exists.
4. Start Azeroth Survivors and enable the addon.
5. Open options with `/azcursor`.

## Smoke tests
- Native cursor remains usable on first launch; no marker is enabled automatically.
- `/azcursor on` enables the marker; `/azcursor off` disables both marker and class icon.
- `/azcursor find` shows a brief beacon, then disappears without enabling the marker.
- Change marker size, thickness, opacity, crosshair, dot, halo and class icon size; preview updates.
- Toggle the class icon with the marker off; confirm icon-only mode.
- Save Quick profile from the settings panel, change settings, then load Quick.
- Save/load/delete named profiles using `/azcursor profile save Raid`, `load Raid`, `delete Raid`.
- Verify FR/EN switching, minimap button movement, color picker Cancel/Apply, and small resolutions.
- Reload UI and restart game: settings and profiles persist.
- Confirm no clicks are intercepted by the cursor overlay.

## Reporting
Include game version, display resolution, UI scale, reproduction steps, expected/actual behavior and a screenshot or short video. Never post private SavedVariables publicly without checking their contents.

## Known beta limits
- Full tabbed UI, profile manager UI, import/export, new art styles and contextual effects are **not** included yet.
- Lua mock tests cannot prove compatibility with every game client; manual testing is mandatory.
