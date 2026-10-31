# Changelog

## 1.1.0 - 2026-10-31

- Class-color shortcuts contributed by [Kohrinthian](https://github.com/Kohrinthian)
  in [PR #1](https://github.com/Maidenquinn/AzerothCursor/pull/1): current class first,
  followed by the other eight classes. Buttons follow the FR/EN language switch.
- Square-minimap support, including KeijinUI, with the complete shortcut outside
  the edge. Rectangular sizes, delayed styling and resizing are handled as well.
- Guard optional class/shape APIs and incomplete class-color tables. Native class
  colors are preferred, with built-in fallback colors when unavailable.
- Preserve saved minimap angles and leave reparented buttons under their collector's control.
- Add native Lua 5.0 regression coverage for all nine classes, both languages,
  color selection, scaled dragging, map shapes/sizes, saved angles and collectors.

## 1.0.0 — 2026-10-29

First public release for Azeroth Survivors on Windows.

- Native cursor only on first installation; enhancements are opt-in.
- High-contrast ring with black outline, adjustable diameter and three thicknesses.
- Opacity, halo intensity, optional animation, crosshair and center dot settings.
- Original, Balanced, Intense combat and Minimal presets with live preview.
- Sliders and +/- controls. Changing a value automatically enables the marker.
- Color picker with hue/saturation wheel, brightness, RGB sliders and hex display.
- Color edits activate the marker; Cancel restores color and prior enabled state.
- Correct Texture-region arguments for the client's four ColorSelect setters.
- Draggable minimap shortcut, saved position and FR/EN options.
- Locate-cursor beacon; all marker overlays allow clicks through.
- Saved preferences in AzerothCursorDB; no gameplay actions or game-save changes.
- Standalone native Lua 5.0 tests and reproducible player packaging.

The maintainer reported the final candidate working and authorized this release.
Automated tests simulate FrameXML; they are not exhaustive rendering certification.
