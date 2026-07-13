import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/theme/theme_mode.dart';
import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/features/auth/presentation/notifiers/auth_session_provider.dart';
import 'package:app/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _switchThemeMode() {
    ref.read(settingsProvider.notifier).toggleThemeMode(context);
  }

  Future<void> _logout() => ref.read(authSessionProvider.notifier).logout();

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: kDebugMode
            ? IconButton(
                onPressed: () => context.push(RoutesDocument.logs),
                icon: const Icon(Icons.bug_report),
                tooltip: 'Log viewer (debug only)',
              )
            : null,
        actions: <Widget>[
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: context.l10n.logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(context.l10n.appName),
            Text(
              settings.themeMode.localize(context),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton.icon(
              onPressed: () => Future.sync(
                () => ref
                    .read(settingsProvider.notifier)
                    .setLocale(
                      settings.locale?.languageCode == 'en'
                          ? const Locale('es')
                          : const Locale('en'),
                    ),
              ),
              icon: const Icon(Icons.language),
              label: Text(context.l10n.localeName),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchThemeMode,
        tooltip: context.l10n.switchTheme,
        child: Icon(
          settings.themeMode.isDark ? Icons.light_mode : Icons.dark_mode,
        ),
      ),
    );
  }
}
