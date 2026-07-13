import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/sizes.dart';
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
    return Center(
      child: SingleChildScrollView(
        padding: Insets.largeAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: IconSize.extraLarge,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: Insets.medium),
            Text(
              context.l10n.defaultErrorMessage,
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Insets.large),
              FilledButton(onPressed: onRetry, child: Text(context.l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}
