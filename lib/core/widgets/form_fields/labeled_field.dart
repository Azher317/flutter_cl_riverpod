import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/constants/sizes.dart';
import 'package:app/core/widgets/flex_padded.dart';
import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.items});

  final String label;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return ColumnPadded(
      gap: Insets.medium,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        ColumnPadded(gap: Insets.medium, children: items),
      ],
    );
  }
}
