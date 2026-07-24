import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/text.dart';
import 'package:flutter/material.dart';

/// Centered icon + title (+ optional message and action) used for the empty and
/// error states. See [EmptyState] and [DefaultErrorWidget] for the presets.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.iconColor,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Color? iconColor;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: Insets.largeAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: IconSize.extraLarge,
              color: iconColor ?? context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: Insets.medium),
            CustomText(
              title,
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: Insets.small),
              CustomText(
                message!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: Insets.large),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
