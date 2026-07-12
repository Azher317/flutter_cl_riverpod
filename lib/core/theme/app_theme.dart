import 'package:app/core/theme/extra_colors.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  // Bundled locally instead of GoogleFonts' runtime-fetched
  // notoSansArabicTextTheme, which downloads the font file over the network
  // on first launch and can flash a fallback font or fail outright offline.
  // Requires the .ttf assets + this pubspec.yaml entry in the real app repo:
  //   fonts:
  //     - family: NotoSansArabic
  //       fonts:
  //         - asset: assets/fonts/NotoSansArabic-Regular.ttf
  //         - asset: assets/fonts/NotoSansArabic-Bold.ttf
  //           weight: 700
  static const String _fontFamily = 'NotoSansArabic';

  static const Color _seedColor = Color(0xFFEE4266);
  static BorderRadius get _radius => BorderRadius.circular(BorderSize.small);

  static EdgeInsets get _fieldPadding =>
      EdgeInsets.symmetric(vertical: 14, horizontal: 12);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: brightness,
        ).copyWith(
          primary: const Color(0xffEE4266),
          secondary: const Color(0xffFFFEFF),
          onSurface: const Color(0xff292A2E),
          onSurfaceVariant: const Color(0xff7A8581),
          surface: const Color(0xffF2F2F2),
          outline: const Color(0xffDDDDDD),
          outlineVariant: const Color(0xffB9B9B9),
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,

      // Core M3 component consistency
      appBarTheme: _appBarTheme(scheme),
      cardTheme: _cardTheme(scheme),
      navigationBarTheme: _navigationBarTheme(scheme),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      splashColor: scheme.primary.withValues(alpha: 0.12),
      highlightColor: scheme.primary.withValues(alpha: 0.05),
      checkboxTheme: _checkboxTheme(scheme),
    );

    final themed = base.copyWith(textTheme: _textTheme(base.textTheme));

    return themed.copyWith(
      filledButtonTheme: _filledButtonTheme(themed.textTheme, scheme),
      inputDecorationTheme: _inputDecorationTheme(scheme, themed.textTheme),
      extensions: <ThemeExtension<dynamic>>[
        AppStatusColors.fromScheme(themed.colorScheme),
      ],
    );
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme c) => CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    side: BorderSide(color: c.onSurfaceVariant, width: 1),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static AppBarTheme _appBarTheme(ColorScheme c) => AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    actionsPadding: EdgeInsets.symmetric(horizontal: Insets.medium),
  );

  static CardThemeData _cardTheme(ColorScheme c) => CardThemeData(
    color: c.surfaceContainerLow,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: _radius),
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
    final t = base.apply(fontFamily: _fontFamily);

    return t.copyWith(
      titleLarge: t.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 36,
        height: 1,
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
      bodySmall: t.bodyMedium?.copyWith(fontSize: 12),
      labelLarge: t.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        fontSize: 14,
      ),
      labelMedium: t.labelMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: t.labelMedium?.copyWith(fontSize: 10, height: 1),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(TextTheme t, ColorScheme c) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: c.onPrimary,
          disabledForegroundColor: c.onPrimary,
          minimumSize: Size(double.infinity, 52),
          maximumSize: Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderSize.largeRadius),
          textStyle: t.labelMedium?.copyWith(color: c.onPrimary),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: _fieldPadding,
          minimumSize: Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderSize.largeRadius),
        ),
      );

  static TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderSize.largeRadius),
    ),
  );
}
