import 'package:app/core/theme/extra_colors.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  /// Also used by [CustomText] so its typography matches the theme's.
  static const String fontFamily = 'NotoSansArabic';

  static const Color _seedColor = Color(0xFFEE4266);
  static BorderRadius get _radius => BorderRadius.circular(BorderSize.small);

  static EdgeInsets get _fieldPadding =>
      const EdgeInsets.symmetric(vertical: 14, horizontal: 12);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      brightness: brightness,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,

      // Core M3 component consistency
      appBarTheme: _appBarTheme(scheme),
      cardTheme: _cardTheme(scheme),
      navigationBarTheme: _navigationBarTheme(scheme),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      datePickerTheme: _datePickerTheme(scheme),
      splashColor: scheme.primary.withValues(alpha: 0.12),
      highlightColor: scheme.primary.withValues(alpha: 0.05),
      checkboxTheme: _checkboxTheme(scheme),
    );

    final themed = base.copyWith(textTheme: _textTheme(base.textTheme));

    return themed.copyWith(
      filledButtonTheme: _filledButtonTheme(themed.textTheme, scheme),
      inputDecorationTheme: _inputDecorationTheme(scheme, themed.textTheme),
      extensions: <ThemeExtension<dynamic>>[AppStatusColors.of(brightness)],
    );
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme c) => CheckboxThemeData(
    shape: const RoundedRectangleBorder(borderRadius: BorderSize.xxsRadius),
    side: BorderSide(color: c.onSurfaceVariant),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static AppBarTheme _appBarTheme(ColorScheme c) => AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: c.surface,
    foregroundColor: c.onSurface,
    actionsPadding: const EdgeInsets.symmetric(horizontal: Insets.medium),
  );

  static CardThemeData _cardTheme(ColorScheme c) => CardThemeData(
    color: c.surfaceContainerLow,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: _radius),
  );

  static DatePickerThemeData _datePickerTheme(ColorScheme c) =>
      DatePickerThemeData(
        backgroundColor: c.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderSize.mediumRadius,
        ),
      );

  static NavigationBarThemeData _navigationBarTheme(ColorScheme c) =>
      NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.secondaryContainer,
        elevation: 0,
      );

  static InputDecorationTheme _inputDecorationTheme(
    ColorScheme c,
    TextTheme t,
  ) {
    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecorationTheme(
      contentPadding: _fieldPadding,
      filled: true,
      fillColor: c.surfaceContainerLowest,
      hintStyle: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
      border: border(Colors.transparent),
      enabledBorder: border(Colors.transparent),
      focusedBorder: border(c.primary),
      errorBorder: border(c.error),
      focusedErrorBorder: border(c.error, width: 2),
      disabledBorder: border(Colors.transparent),
      activeIndicatorBorder: BorderSide.none,
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    final t = base.apply(fontFamily: fontFamily);

    return t.copyWith(
      // Hero text (was living on titleLarge). Kept at 36 for existing screens.
      displaySmall: t.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 36,
        height: 1.2,
      ),
      titleLarge: t.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 22,
        height: 1.2,
      ),
      titleMedium: t.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
        fontSize: 18,
      ),
      titleSmall: t.titleSmall?.copyWith(
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

  static FilledButtonThemeData _filledButtonTheme(TextTheme t, ColorScheme c) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: c.onPrimary,
          // Let M3's default disabled foreground (onSurface @ 38%) signal the
          // disabled state instead of forcing full-strength onPrimary.
          minimumSize: const Size(double.infinity, 52),
          maximumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderSize.largeRadius,
          ),
          // Color comes from foregroundColor; keep it out of textStyle so the
          // disabled color can apply.
          textStyle: t.labelMedium,
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: _fieldPadding,
          minimumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderSize.largeRadius,
          ),
        ),
      );

  static TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const RoundedRectangleBorder(borderRadius: BorderSize.largeRadius),
    ),
  );
}
