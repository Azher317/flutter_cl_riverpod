import 'package:app/core/theme/extra_colors.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
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
    final (Color bg, Color fg, icon) = switch (type) {
      MessageType.success => (
        status.success,
        status.onSuccess,
        Icons.check_circle_rounded,
      ),
      MessageType.error => (scheme.error, scheme.onError, Icons.error_rounded),
      MessageType.warning => (
        status.warning,
        status.onWarning,
        Icons.warning_rounded,
      ),
      MessageType.info => (status.info, status.onInfo, Icons.info_rounded),
    };

    state
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          // Behaviour, elevation, insets and shape come from `snackBarTheme`;
          // only what varies per MessageType is set here.
          backgroundColor: bg,
          duration: const Duration(seconds: 3),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          dismissDirection: DismissDirection.horizontal,
          content: Row(
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  // Weight and height come from the theme's contentTextStyle;
                  // only the per-type foreground is applied here.
                  style: TextStyle(color: fg),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
