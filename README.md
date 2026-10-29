# Azeroth Cursor 1.0.0

Find your mouse in the middle of spell effects in **Azeroth Survivors** on Windows.
Standalone Interface 11200 / Lua 5.0 addon. French and English settings.

## Download and install

Download **AzerothCursor-1.0.0.zip** from the [GitHub release](https://github.com/Maidenquinn/AzerothCursor/releases/tag/v1.0.0).
Close the game and extract the `AzerothCursor` folder into the active installation's
`benilla-config/AddOns` folder. Enable the addon if needed and restart the game.
GitHub's automatic **Source code** ZIP is for developers, not direct installation.

Open settings with the **cyan minimap button** or `/azcursor` (`/azcur` also works).
Drag the minimap button around the rim to reposition it.

**Your original cursor is kept on first installation, with no added effects.**
Choose a preset, enable **Cursor marker**, or adjust a slider/color to activate it.
The **Original** preset disables the effects again. Simply opening settings or the
color picker does not enable them. Settings persist through normal game shutdown.

## Features

- High-contrast ring with black outline, diameter 24–160 UI units and three thicknesses.
- Marker opacity, halo intensity, optional halo animation, crosshair and center dot.
- Sliders and +/- buttons for precise adjustments; edits automatically enable the marker.
- **Choose color**: hue/saturation wheel, brightness, RGB sliders and hex display.
  Changes appear live. **Apply** keeps them; **Cancel** or Escape restores the previous
  color and enabled state. `/azcursor color #FF00CC` also works.
- **Original**, **Balanced**, **Intense combat** and **Minimal** presets; live preview.
- **Locate cursor** or `/azcursor find`: a converging white beacon for 1.2 seconds.
  This action enables the marker and can be used in a macro.
- French/English language switch, draggable settings window and minimap shortcut.

## Commands

- `/azcursor`: toggle settings.
- `/azcursor on` or `/azcursor off`: enable/disable the marker.
- `/azcursor native|balanced|raid|minimal`: select a preset.
- `/azcursor color #RRGGBB`: choose a custom color and enable the marker.
- `/azcursor find`: locate the cursor.
- `/azcursor fr` or `/azcursor en`: choose the settings language.
- `/azcursor reset`: restore initial settings, including the original cursor.

## Behavior and limits

The addon adds a marker around the exact click point. It does not replace, resize
or recolor the native pointer, which keeps its interaction, item and spell states.
All marker overlays allow clicks through. Sizes follow the UI scale.

The marker uses TOOLTIP strata above Lua frames, hides during mouselook and when
the reported position is outside UI bounds. Native engine panels can have their
own rendering order. No reliable window-focus signal is used, so a stale marker
may remain visible when the mouse leaves the game window.

Only `AzerothCursorDB` is persisted by the normal game cycle. No CVars, game saves,
combat actions, outgoing messages or other addons' files are modified. No position
history is retained. All eleven TGA masks are original procedural assets generated
by `tools/generate_media.py`, using only Python's standard library.

Upgrading from the first 0.1 beta disables its automatic marker once while keeping
appearance settings. Explicit choices in 0.2 and later are retained.

## Development and validation

Python 3 and a native **Lua 5.0** interpreter are needed for testing. No other addon,
Python package, game files or SavedVariables are required.

```sh
python tests/run.py --lua50 /path/to/lua50
python tools/build_release.py
```

Alternatively set `LUA50`, or put `lua5.0` / `lua50` on PATH. Tests cover loading,
TOC/version consistency, scaled geometry, persistence sanitization, defaults,
migration, controls, minimap placement, automatic activation, strict ColorSelect
Texture-region arguments, color cancellation and click transparency.
The builder creates the player ZIP and SHA-256 file in `dist/`.

The maintainer reported the final candidate working in game and authorized 1.0.
Tests simulate FrameXML and do not certify every native rendering path. Further
testing should check controls, point alignment at different UI scales, spell
effects, item dragging, mouselook, native menus and persistence.

## Français

Fermer le jeu, extraire le dossier `AzerothCursor` du ZIP de la release dans
`benilla-config/AddOns`, puis relancer. Ouvrir les options avec le **bouton cyan
de la minicarte** ou `/azcursor` ; le bouton **Français** change la langue.

Le curseur d'origine est conservé à l'installation. Modifier un slider, un +/−
ou une couleur active automatiquement le repère. **Origine** désactive les effets.
Le colorpicker propose roue, luminosité et RVB ; **Annuler** restaure aussi l'état
d'activation précédent. Le repère laisse passer les clics et ne remplace pas le
pointeur natif. Les préférences persistent après une fermeture normale du jeu.

[Changelog](CHANGELOG.md) · [Report an issue](https://github.com/Maidenquinn/AzerothCursor/issues)
