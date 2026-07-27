import 'package:app/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

/// The app's type scale: Material's [TextTheme] with the project's sizes,
/// weights and — via [AppFontScheme] — the right families for the active
/// script.
class AppTextTheme {
  const AppTextTheme._();

  /// The role → family contract: `display*`, `headline*` and `title*` get
  /// [AppFontScheme.display]; `body*` and `label*` keep [AppFontScheme.body]
  /// from the baseline `.apply()`. Sizes and weights are script-agnostic — only
  /// the family changes between locales.
  static TextTheme build(TextTheme base, AppFontScheme fonts) {
    final t = base.apply(fontFamily: fonts.body);

    return t.copyWith(
      // Display / headline: family only, Material's own metrics are kept.
      displayLarge: t.displayLarge?.copyWith(fontFamily: fonts.display),
      displayMedium: t.displayMedium?.copyWith(fontFamily: fonts.display),
      headlineLarge: t.headlineLarge?.copyWith(fontFamily: fonts.display),
      headlineMedium: t.headlineMedium?.copyWith(fontFamily: fonts.display),
      headlineSmall: t.headlineSmall?.copyWith(fontFamily: fonts.display),
      // Hero text (was living on titleLarge). Kept at 36 for existing screens.
      displaySmall: t.displaySmall?.copyWith(
        fontFamily: fonts.display,
        fontWeight: FontWeight.w700,
        fontSize: 36,
        height: 1.2,
      ),
      titleLarge: t.titleLarge?.copyWith(
        fontFamily: fonts.display,
        fontWeight: FontWeight.w700,
        fontSize: 22,
        height: 1.2,
      ),
      titleMedium: t.titleMedium?.copyWith(
        fontFamily: fonts.display,
        fontWeight: FontWeight.w600,
        height: 1.3,
        fontSize: 18,
      ),
      titleSmall: t.titleSmall?.copyWith(
        fontFamily: fonts.display,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: -0.41,
      ),
      bodyLarge: t.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: t.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: t.bodySmall?.copyWith(fontSize: 12),
      labelLarge: t.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        fontSize: 14,
      ),
      labelMedium: t.labelMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: t.labelSmall?.copyWith(fontSize: 10, height: 1.2),
    );
  }
}
