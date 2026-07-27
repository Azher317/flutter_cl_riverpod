import 'package:app/core/theme/app_fonts.dart';
import 'package:app/core/theme/app_text_theme.dart';
import 'package:app/core/theme/colors/color_schemes.dart';
import 'package:app/core/theme/component_themes.dart';
import 'package:app/core/theme/extra_colors.dart';
import 'package:flutter/material.dart';

/// Assembles the app's `ThemeData`. The pieces live next door: the palette in
/// `AppColors` and [AppColorSchemes], per-component styling in
/// [AppComponentThemes], the type scale in [AppTextTheme], the shared radii in
/// [AppShapes], and the status palette in [AppStatusColors].
class AppTheme {
  const AppTheme._();

  /// [fonts] picks the font families for the active script — pass
  /// `AppFontScheme.of(locale)` from the composition root (see `App` in
  /// lib/app.dart). Defaults to [AppFontScheme.latin] so tests and one-off
  /// `AppTheme.light()` calls keep working.
  static ThemeData light({AppFontScheme fonts = AppFontScheme.latin}) =>
      _build(Brightness.light, fonts);

  static ThemeData dark({AppFontScheme fonts = AppFontScheme.latin}) =>
      _build(Brightness.dark, fonts);

  static ThemeData _build(Brightness brightness, AppFontScheme fonts) {
    final scheme = AppColorSchemes.brand(brightness);

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      // App-wide default; the display face is applied per-role in AppTextTheme.
      fontFamily: fonts.body,

      // Core M3 component consistency
      appBarTheme: AppComponentThemes.appBar(scheme),
      cardTheme: AppComponentThemes.card(scheme),
      navigationBarTheme: AppComponentThemes.navigationBar(scheme),
      outlinedButtonTheme: AppComponentThemes.outlinedButton(),
      textButtonTheme: AppComponentThemes.textButton(),
      datePickerTheme: AppComponentThemes.datePicker(scheme),
      splashColor: scheme.primary.withValues(alpha: 0.12),
      checkboxTheme: AppComponentThemes.checkbox(scheme),
      bottomSheetTheme: AppComponentThemes.bottomSheet(scheme),
      dialogTheme: AppComponentThemes.dialog(scheme),
      dividerTheme: AppComponentThemes.divider(scheme),
      progressIndicatorTheme: AppComponentThemes.progressIndicator(scheme),
      iconTheme: AppComponentThemes.icon(scheme),
      iconButtonTheme: AppComponentThemes.iconButton(scheme),
    );

    final themed = base.copyWith(
      textTheme: AppTextTheme.build(base.textTheme, fonts),
    );

    // Themes that read from the app's own TextTheme have to wait for it —
    // `base.textTheme` is still Material's default above.
    return themed.copyWith(
      filledButtonTheme: AppComponentThemes.filledButton(
        themed.textTheme,
        scheme,
      ),
      inputDecorationTheme: AppComponentThemes.inputDecoration(
        scheme,
        themed.textTheme,
      ),
      snackBarTheme: AppComponentThemes.snackBar(themed.textTheme),
      listTileTheme: AppComponentThemes.listTile(themed.textTheme),
      extensions: <ThemeExtension<dynamic>>[AppStatusColors.of(brightness)],
    );
  }
}
