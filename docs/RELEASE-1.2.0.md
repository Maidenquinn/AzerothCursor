# Azeroth Cursor 1.2.0 — Optional Class Icons

Show your class crest on the cursor — or keep the ring alone. Marker and icon are
independent. Thanks to **Joker / Kohrinthian** for the class masks in
[PR #2](https://github.com/Maidenquinn/AzerothCursor/pull/2)!

## Optional class icon

- Toggle **Class icon** / **Icône de classe** (**off by default**).
- Use the icon alone, the ring marker alone, or both together.
- All nine classes, including Rogue / Voleur, as circular white masks that tint
  with your marker color.
- Dedicated **class icon size** slider (8–120).
- With the icon on, class-color buttons also choose which crest to display.

## Randomize and polish

- **Random** / **Aléatoire** (and `/azcursor random`): marker stays on; randomizes
  halo, class icon, sliders, color and icon token.
- Live cursor overlay while options are open.
- Preview keeps the same marker/icon proportions as the real cursor.
- Texture reload when switching class so preview and live stay in sync.

## Download and update

Download **AzerothCursor-1.2.0.zip** below. Close the game, replace the `AzerothCursor`
folder in your active `benilla-config/AddOns` directory, keep `AzerothCursorDB`, and restart.
Open the cyan minimap button or `/azcursor`.

Use the attached player ZIP rather than GitHub's automatic source archive.
Your saved settings and original-cursor default are preserved. No other addon is required.

## Validation

Native Lua 5.0.3 regression tests cover optional/independent class icons, all nine
masks, Random, preview proportions, FR/EN, class colors, scaled maps and persistence.
Runtime syntax, TOC/version consistency and all twenty TGA assets pass as well.

Tests simulate FrameXML behavior; keep an eye on native rendering after `/reload`.

[Full changelog](https://github.com/Maidenquinn/AzerothCursor/blob/v1.2.0/CHANGELOG.md) · [Report an issue](https://github.com/Maidenquinn/AzerothCursor/issues)
