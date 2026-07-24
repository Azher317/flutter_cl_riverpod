---
paths:
  - "lib/core/theme/**"
---

# Theming

[app_theme.dart](../../lib/core/theme/app_theme.dart) assembles `ThemeData` in two phases
(component themes that need the app's own `TextTheme` are applied after it exists).
The pieces:

| Concern | File | Notes |
|---|---|---|
| Raw hexes | [colors/app_colors.dart](../../lib/core/theme/colors/app_colors.dart) | Brand + success/warning/info seeds. **Placeholder values** — the only file to edit when rebranding. |
| `ColorScheme`s | [colors/color_schemes.dart](../../lib/core/theme/colors/color_schemes.dart) | `ColorScheme.fromSeed` + pinned `primary`. Light/dark from one call. |
| Non-M3 status colours | [extra_colors.dart](../../lib/core/theme/extra_colors.dart) | `AppStatusColors` theme extension; read via `Theme.of(context).appStatusColors`. |
| Per-component styling | [component_themes.dart](../../lib/core/theme/component_themes.dart) | One builder per Material component. Radii come from the private `_AppShapes` tiers, never ad-hoc numbers. |
| Type scale | [app_text_theme.dart](../../lib/core/theme/app_text_theme.dart) | `display*`/`headline*`/`title*` get the display face; `body*`/`label*` the body face. |
| Font families | [app_fonts.dart](../../lib/core/theme/app_fonts.dart) | `AppFontScheme.of(locale)` picks Latin vs Arabic faces; wired in [app.dart](../../lib/app.dart). Names must match `pubspec.yaml` `family:` keys exactly. |
| Spacing / radii / durations | [sizes.dart](../../lib/core/utils/constants/sizes.dart) | `Insets`, `BorderSize`, `IconSize`, `BorderWidth`, `Time`. Use these, not magic numbers. |

Shortcuts: `context.theme`, `context.colorScheme`, `context.textTheme`
([theme_extentions.dart](../../lib/core/utils/extensions/theme_extentions.dart)).
