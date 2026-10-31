# Azeroth Cursor 1.1.0 — Class Colors & Minimap Improvements

Pick your class color in one click and keep the minimap shortcut where it belongs.
Thanks to **Joker / Kohrinthian** for the original contribution in [PR #1](https://github.com/Maidenquinn/AzerothCursor/pull/1)!

## Class-color shortcuts

- Nine class-color buttons in settings: your current class first, followed by the other eight classes.
- Clicking a class color applies it and automatically enables the marker.
- Labels follow the French/English language switch.
- Native class colors are preferred; built-in fallback colors cover missing or invalid client data.

## Minimap improvements

- Support for square minimaps, including KeijinUI, with the complete shortcut outside the edge.
- Correct placement for rectangular maps and different UI scales.
- Adaptation to map resizing or delayed shape changes, plus saved-angle restoration after world entry.
- Respect for button collectors that reparent the shortcut.
- Optional class/shape integrations are guarded against missing or invalid data.
- Adjusted settings layout so the footer does not overlap the class-color grid.

## Download and update

Download **AzerothCursor-1.1.0.zip** below. Close the game, replace the `AzerothCursor`
folder in your active `benilla-config/AddOns` directory, keep `AzerothCursorDB`, and restart.
Open the cyan minimap button or `/azcursor`.

Use the attached player ZIP rather than GitHub's automatic source archive.
Your saved settings and original-cursor default are preserved. No other addon is required.

## Validation

Expanded native Lua 5.0.3 regression tests cover all nine classes, FR/EN labels,
native and fallback colors, scaled dragging, square/round/rectangular maps,
saved-angle reloads, optional APIs and button collectors. Runtime syntax,
TOC/version consistency and all eleven texture assets pass as well.

Tests simulate FrameXML behavior; native KeijinUI rendering remains to be confirmed in game.

[Full changelog](https://github.com/Maidenquinn/AzerothCursor/blob/v1.1.0/CHANGELOG.md) · [Report an issue](https://github.com/Maidenquinn/AzerothCursor/issues)
