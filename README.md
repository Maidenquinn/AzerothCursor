# Azeroth Cursor 1.2.0

Find your mouse in the middle of spell effects in **Azeroth Survivors** on Windows.
Standalone Interface 11200 / Lua 5.0 addon. French and English settings.

## Download and install

Download **AzerothCursor-1.2.0.zip** from the [GitHub release](https://github.com/Maidenquinn/AzerothCursor/releases/tag/v1.2.0).
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

### Class colors, optional class icon and minimap compatibility

Thanks to [Kohrinthian](https://github.com/Kohrinthian)
([PR #1](https://github.com/Maidenquinn/AzerothCursor/pull/1) colors,
[PR #2](https://github.com/Maidenquinn/AzerothCursor/pull/2) icons),
settings offer class-color shortcuts (current class first) and an **optional**
class icon (**off by default**, independent of the ring marker — icon only, marker
only, or both). All nine circular white masks (including Rogue) tint with the
marker color. Size is adjustable. Toggle **Class icon** / **Icône de classe**;
with it on, class buttons also pick the icon. **Random** / **Aléatoire** keeps the
marker on and randomizes the rest.

Native class colors are preferred, with fallbacks if the client omits that table.
The minimap shortcut supports square maps through KeijinUI or `GetMinimapShape`,
stays outside their edge, and adapts to rectangular sizes or delayed UI styling.
Collectors that reparent addon buttons keep control of the shortcut.

## Commands

- `/azcursor`: toggle settings.
- `/azcursor on` or `/azcursor off`: enable/disable the marker.
- `/azcursor native|balanced|raid|minimal`: select a preset.
- `/azcursor color #RRGGBB`: choose a custom color and enable the marker.
- `/azcursor find`: locate the cursor.
- `/azcursor random`: randomize appearance (marker stays on).
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
history is retained. Marker TGAs are original procedural assets from
`tools/generate_media.py`. Class masks are based on Kohrinthian's PR #2 art
(Rogue adapted to the same circular white style).

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

The maintainer validated the optional class-icon flow in game for 1.2.0.
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
