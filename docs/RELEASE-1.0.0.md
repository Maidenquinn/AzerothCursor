# Azeroth Cursor 1.0.0

Keep track of your mouse when the screen fills with spell effects in Azeroth Survivors.

## Features

- High-contrast cursor ring with black outline, adjustable size, thickness and opacity.
- Optional halo and animation, crosshair and center dot.
- Original, Balanced, Intense combat and Minimal presets with live preview.
- Sliders and +/- buttons. Editing a value enables the marker immediately.
- Color wheel, brightness control and RGB sliders. Cancel restores the previous color and enabled state.
- Draggable minimap shortcut, saved preferences and French/English options.
- Locate-cursor beacon with `/azcursor find`.

The native cursor stays unchanged on first installation. Effects activate when
you choose them; all marker overlays allow clicks through. No other addon is required.

## Installation

Download **AzerothCursor-1.0.0.zip**, close the game, and extract the
`AzerothCursor` folder into the active `benilla-config/AddOns` directory.
Enable the addon if needed and restart. Open the cyan minimap button or `/azcursor`.
Keep existing `AzerothCursorDB` when updating from a test build.

**Use the attached player ZIP, not GitHub's automatic source archive.**
The matching `.sha256` file lets you check the download.

The maintainer reported the final candidate working in game and authorized 1.0.
Standalone native Lua 5.0 tests cover behavior, settings, strict ColorSelect texture
arguments and regressions. They do not certify every native rendering path.

[Changelog](https://github.com/Maidenquinn/AzerothCursor/blob/v1.0.0/CHANGELOG.md) · [Report an issue](https://github.com/Maidenquinn/AzerothCursor/issues)
