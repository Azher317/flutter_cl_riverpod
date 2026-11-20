import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/buttons/filled_loading_button.dart';
import 'package:app/core/widgets/column_padded.dart';
import 'package:app/core/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A dialog with a title, any content, and Add / Cancel buttons. For a plain
/// message with OK, use `showDialog` + `AlertDialog` from `core/widgets` only.
class CustomDialog extends HookConsumerWidget {
  const CustomDialog({
    super.key,
    required this.children,
    required this.titleText,
    required this.isLoading,
    required this.onAdd,
  });
  final List<Widget> children;
  final String titleText;
  final bool isLoading;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.medium),
        child: ColumnPadded(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(titleText, style: context.textTheme.displaySmall),
            ...children,
            Row(
              children: [
                FilledLoadingButton(
                  isLoading: isLoading,
                  onPressed: onAdd,
                  child: CustomText(context.l10n.add),
                ),
                const SizedBox(width: Insets.small),
                FilledButton(
                  onPressed: context.pop,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colorScheme.error,
                    foregroundColor: context.colorScheme.onError,
                  ),
                  child: CustomText(context.l10n.cancel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
