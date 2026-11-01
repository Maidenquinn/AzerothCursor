# Changelog

## 1.2.0 - 2026-11-01

Optional class icons, built on the circular white masks contributed by
[Kohrinthian](https://github.com/Kohrinthian) in
[PR #2](https://github.com/Maidenquinn/AzerothCursor/pull/2). Thank you!

- **Class icon** toggle (**off by default**), independent of the cursor marker:
  icon only, marker only, or both.
- All nine class masks (Warrior through Druid), including Rogue / Voleur.
- Dedicated **class icon size** slider; icons tint with the marker color.
- With the icon enabled, class buttons also pick which crest to show.
- **Random** button and `/azcursor random`: marker stays on; randomizes halo,
  class icon, sliders, color and icon token.
- Live overlay while options are open; preview keeps the same marker/icon
  proportions as the real cursor.
- Texture reload when switching class so the preview and live cursor stay in sync.

### Review trail (same day)

- review.1–.2: optional icon API, independent marker/icon, size slider, layout.
- review.3: live overlay in options; shared color tint; preview fitting.
- review.4: Rogue crest added.
- review.5: Random / Aléatoire.
- review.6: character-creation atlas trial (reverted).
- review.7: circular white masks restored; Rogue adapted to match.

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
