import 'package:app/core/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

/// The `ColorScheme`s derived from [AppColors], one builder per palette.
///
/// Every builder takes a [Brightness] and is the *only* thing that turns a raw
/// hex into a usable set of roles. That's what makes dark mode cheap: light and
/// dark come out of the same call, so dark can never silently lag behind light.
///
/// ───────────────────────────────────────────────────────────────────────────
/// ⚠️  PLACEHOLDER PALETTE — see the note in colors/app_colors.dart.
/// The seeds below are template defaults. Swap them for the app's real palette
/// when you start a new project; no widget or component theme needs to change.
/// ───────────────────────────────────────────────────────────────────────────
///
/// The approach used here is "seed + pinned role": Material 3 derives the whole
/// harmonized palette from one seed, and `primary:` pins the exact hex so the
/// brand colour survives the derivation untouched. See the note at the bottom
/// of this file for the stricter alternative.
class AppColorSchemes {
  const AppColorSchemes._();

  /// The app-wide scheme consumed by `AppTheme._build`.
  static ColorScheme brand(Brightness b) => ColorScheme.fromSeed(
    seedColor: AppColors.brand,
    brightness: b,
    primary: AppColors.brand,
  );

  /// Dedicated, brightness-aware status palettes. Seeded from fixed green /
  /// amber / blue so success/warning/info stay recognizable regardless of the
  /// brand seed. Consumed by `AppStatusColors.of`.
  static ColorScheme success(Brightness b) => ColorScheme.fromSeed(
    seedColor: AppColors.success,
    brightness: b,
    primary: AppColors.success,
  );

  static ColorScheme warning(Brightness b) => ColorScheme.fromSeed(
    seedColor: AppColors.warning,
    brightness: b,
    primary: AppColors.warning,
  );

  static ColorScheme info(Brightness b) => ColorScheme.fromSeed(
    seedColor: AppColors.info,
    brightness: b,
    primary: AppColors.info,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// ALTERNATIVE: two fully explicit schemes instead of a seed
// ─────────────────────────────────────────────────────────────────────────────
//
// Seeding derives ~30 roles from one colour, so it will not reproduce specific
// hexes beyond the ones pinned above. When the designer hands over a complete
// system — every surface, every text tone, both light and dark, and it has to
// match pixel-for-pixel — declare the two schemes outright and stop seeding:
//
//   static const ColorScheme _light = ColorScheme(
//     brightness: Brightness.light,
//     primary: ..., onPrimary: ..., primaryContainer: ..., onPrimaryContainer: ...,
//     secondary: ..., onSecondary: ..., secondaryContainer: ..., /* ... */
//     surface: ..., onSurface: ..., surfaceContainerLow: ...,
//     outline: ..., outlineVariant: ..., error: ..., onError: ...,
//   );
//   static const ColorScheme _dark = ColorScheme(brightness: Brightness.dark, /* ... */);
//
//   static ColorScheme brand(Brightness b) =>
//       b == Brightness.dark ? _dark : _light;
//
// Only this one method changes — `AppTheme._build` and every component theme
// keep working untouched, because they read from `scheme` and never from a hex:
//
//   // app_theme.dart (illustration — not applied)
//   static ThemeData _build(Brightness brightness, AppFontScheme fonts) {
//     final scheme = AppColorSchemes.brand(brightness);  // ← unchanged line
//     final base = ThemeData(
//       useMaterial3: true,
//       brightness: brightness,
//       colorScheme: scheme,
//       fontFamily: fonts.body,
//       // ...all component themes stay identical, they read from `scheme`
//     );
//     // ...rest unchanged
//   }
//
// The trade-off: you now own light/dark correctness for every role you pinned.
// A light-only brand hex can fail contrast on dark, so both schemes have to be
// specified and contrast-checked (WCAG AA — 4.5:1 body text, 3:1 large text and
// UI) rather than trusted to Material's tonal derivation. The same applies to
// the status palettes above: if the design specifies both light and dark status
// hexes, branch on `b` and return the exact values instead of seeding.
