import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/text.dart';
import 'package:flutter/material.dart';

enum MessageType { success, error, warning, info }

class AppMessenger {
  const AppMessenger._();

  static final key = GlobalKey<ScaffoldMessengerState>();

  /// Shows [text]. With an [action] ("Undo", "Retry") it stays 5 s instead
  /// of 3 s, and still goes away by itself: Flutter would otherwise keep a
  /// snackbar with an action on screen until it is swiped away.
  static void show(
    String? text, {
    MessageType type = MessageType.info,
    SnackBarAction? action,
  }) {
    if (text == null || text.isEmpty) return;
    final state = key.currentState;
    final context = key.currentContext;
    if (state == null || context == null) return;

    final scheme = context.colorScheme;
    final status = context.appStatusColors;
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
          duration: Duration(seconds: action == null ? 3 : 5),
          action: action,
          persist: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          dismissDirection: DismissDirection.horizontal,
          content: Row(
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: CustomText(
                  text,
                  maxLines: 3,
                  // Weight and height come from the theme's contentTextStyle;
                  // only the per-type foreground is applied here.
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
