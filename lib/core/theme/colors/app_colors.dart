import 'package:flutter/material.dart';

/// Every raw colour value the app owns, in one place.
///
/// ───────────────────────────────────────────────────────────────────────────
/// ⚠️  PLACEHOLDER COLOURS — template defaults, not brand colours.
///
/// These hexes exist so a fresh clone looks finished out of the box. When you
/// start a new app, replace them with the real palette from the designer's
/// handoff — edit the constants *here* and nothing else needs touching, because
/// no widget in the codebase names a colour directly: widgets read roles off
/// `Theme.of(context).colorScheme` and `appStatusColors`, and those resolve
/// through [AppColorSchemes] in colors/color_schemes.dart.
///
/// Keep it that way. A widget written as `scheme.primary` is automatically
/// correct in dark mode; a widget written as `Color(0xFFF5A2C0)` is frozen to
/// one theme forever.
/// ───────────────────────────────────────────────────────────────────────────
///
/// [brand] seeds the whole `ColorScheme`. The three status colours are seeded
/// separately so success/warning/info stay recognizably green/amber/blue no
/// matter what the brand seed is — they are not Material 3 roles (only `error`
/// is), so they live in the [AppStatusColors] theme extension instead.
class AppColors {
  const AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color brand = Color(0xff4c662b);

  // ── Status ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF5FBE8C);
  static const Color warning = Color(0xFFF0B54E);
  static const Color info = Color(0xFF5FB4DE);
}
