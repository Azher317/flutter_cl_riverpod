import 'package:app/core/l10n/generated/app_localizations.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/theme_reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A tiny app whose theme and locale live in local state, behind a
/// [ThemeRevealHost] like lib/app.dart.
class _RevealApp extends StatefulWidget {
  const _RevealApp({required this.reduceMotion});

  final bool reduceMotion;

  @override
  State<_RevealApp> createState() => _RevealAppState();
}

class _RevealAppState extends State<_RevealApp> {
  ThemeMode mode = ThemeMode.light;
  Locale locale = const Locale('ar');
  int counterKeptAcrossChanges = 0;

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQueryData(disableAnimations: widget.reduceMotion),
    child: MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => ThemeRevealHost(child: child!),
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(
            children: [
              Text('count $counterKeptAcrossChanges'),
              TextButton(
                onPressed: () => setState(() => counterKeptAcrossChanges++),
                child: const Text('inc'),
              ),
              TextButton(
                onPressed: () => context.revealThemeChange(
                  ThemeMode.dark,
                  apply: () => setState(() => mode = ThemeMode.dark),
                ),
                child: const Text('dark'),
              ),
              TextButton(
                onPressed: () => context.revealLocaleChange(
                  const Locale('en'),
                  apply: () => setState(() => locale = const Locale('en')),
                ),
                child: const Text('english'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Language-change tests need Arabic and English; a one-language app skips
/// them.
final _noLanguagePair = !{'ar', 'en'}.every(
  (code) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == code),
);

void main() {
  Brightness brightness(WidgetTester tester) =>
      Theme.of(tester.element(find.text('inc'))).brightness;
  TextDirection direction(WidgetTester tester) =>
      Directionality.of(tester.element(find.text('inc')));

  testWidgets('reduced motion: the theme switches at once', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: _RevealApp(reduceMotion: true)),
    );
    await tester.tap(find.text('dark'));
    await tester.pumpAndSettle();
    expect(brightness(tester), Brightness.dark);
  });

  testWidgets('reduced motion: the language flips to LTR at once', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: _RevealApp(reduceMotion: true)),
    );
    expect(direction(tester), TextDirection.rtl);
    await tester.tap(find.text('english'));
    await tester.pumpAndSettle();
    expect(direction(tester), TextDirection.ltr);
  }, skip: _noLanguagePair);

  testWidgets('a change keeps the app state underneath', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: _RevealApp(reduceMotion: true)),
    );
    await tester.tap(find.text('inc'));
    await tester.pump();
    await tester.tap(find.text('dark'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('english'));
    await tester.pumpAndSettle();
    expect(find.text('count 1'), findsOneWidget);
  }, skip: _noLanguagePair);
}
