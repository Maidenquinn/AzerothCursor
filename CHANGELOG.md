# Changelog

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
