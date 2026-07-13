import 'package:app/core/l10n/generated/app_localizations.dart';
import 'package:app/main.dart';
import 'package:app/router/app_router.dart';
import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/l10n/kurdish/kurdish_material_localization_delegate.dart';
import 'package:app/core/l10n/kurdish/kurdish_widget_localization_delegate.dart';
import 'package:app/core/messaging/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/extensions/common_extensions.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    final localeCode = ref.watch(settingsProvider.select((s) => s.locale));
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: appName,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      scaffoldMessengerKey: AppMessenger.key,
      // Locale
      locale: localeCode,
      onGenerateTitle: (context) => context.l10n.appName,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        KurdishMaterialLocalizations.delegate,
        KurdishWidgetLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Theme
      themeMode: themeMode,
      darkTheme: AppTheme.dark(),
      theme: AppTheme.light(),
    );
  }
}
