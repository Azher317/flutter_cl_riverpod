import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/widgets/flex_padded.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future showThemePickerDialog({required WidgetRef ref}) {
  final themeMode = ref.read(settingsProvider).themeMode;

  final context = ref.context;

  final themes = <({String name, Widget widget, ThemeMode mode})>[
    (
      name: context.l10n.themeSystem,
      widget: const Icon(Icons.settings_suggest),
      mode: ThemeMode.system,
    ),
    (
      name: context.l10n.themeLight,
      widget: const Icon(Icons.light_mode),
      mode: ThemeMode.light,
    ),
    (
      name: context.l10n.themeDark,
      widget: const Icon(Icons.dark_mode),
      mode: ThemeMode.dark,
    ),
  ];

  return showDialog(
    context: ref.context,
    builder: (context) {
      return AlertDialog(
        title: Text(context.l10n.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final theme in themes)
              RadioListTile<ThemeMode>(
                title: RowPadded(
                  children: [
                    theme.widget,
                    Expanded(child: Text(theme.name)),
                  ],
                ),
                value: theme.mode,
                groupValue: themeMode,
                onChanged: (ThemeMode? value) {
                  if (value == null) return;
                  ref
                      .read(settingsProvider.notifier)
                      .update((state) => state.copyWith(themeMode: value));
                  context.pop();
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.cancel),
          ),
        ],
      );
    },
  );
}
