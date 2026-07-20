import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/state_ui/state_message.dart';
import 'package:flutter/material.dart';

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget(
    this.error,
    this.stackTrace, {
    super.key,
    this.onRetry,
  });

  final Object error;
  final StackTrace stackTrace;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return StateMessage(
      icon: Icons.error_outline,
      iconColor: context.colorScheme.error,
      title: context.l10n.defaultErrorMessage,
      action: onRetry == null
          ? null
          : FilledButton(onPressed: onRetry, child: Text(context.l10n.retry)),
    );
  }
}
