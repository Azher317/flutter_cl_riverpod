import 'package:app/core/settings/app_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SwitchThemeModeButton extends HookConsumerWidget {
  const SwitchThemeModeButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(settingsProvider).themeMode == ThemeMode.dark;

    return IconButton(
      onPressed: () {
        ref.read(settingsProvider.notifier).toggleThemeMode(context);
      },
      icon: Icon(
        isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      ),
    );
  }
}
