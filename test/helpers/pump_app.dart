import 'package:app/core/l10n/generated/app_localizations.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] inside the app's theme and localizations (Arabic by
/// default, the app's default language). [size] sets the window (logical
/// pixels) for layout tests; without it `MediaQuery.sizeOf` is zero, which
/// lays out as a phone.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('ar'),
  ThemeMode themeMode = ThemeMode.light,
  bool disableAnimations = false,
  Size? size,
}) async {
  if (size != null) setWindowSize(tester, size);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size ?? Size.zero,
        disableAnimations: disableAnimations,
      ),
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pump();
}

/// Sizes the test window to [size] logical pixels (at 3×) until the test
/// ends.
void setWindowSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}
