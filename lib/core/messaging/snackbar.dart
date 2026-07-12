import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/extra_colors.dart';
import 'package:flutter/material.dart';

enum MessageType { success, error, warning, info }

class AppMessenger {
  const AppMessenger._();

  static final key = GlobalKey<ScaffoldMessengerState>();

  static void show(String? text, {MessageType type = MessageType.info}) {
    if (text == null || text.isEmpty) return;
    final state = key.currentState;
    final context = key.currentContext;
    if (state == null || context == null) return;

    final scheme = context.colorScheme;
    final status = Theme.of(context).appStatusColors;
    final (Color bg, Color fg) = switch (type) {
      MessageType.success => (status.successContainer, status.onSuccessContainer),
      MessageType.error => (scheme.errorContainer, scheme.onErrorContainer),
      MessageType.warning => (status.warning, status.onWarning),
      MessageType.info => (scheme.secondaryContainer, scheme.onSecondaryContainer),
    };

    state
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg,
        content: Text(text, style: context.textTheme.bodyMedium?.copyWith(color: fg)),
      ));
  }
}
