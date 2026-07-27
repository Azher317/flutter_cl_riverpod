import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/column_padded.dart';
import 'package:app/core/widgets/text.dart';
import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.items});

  final String label;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return ColumnPadded(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        ColumnPadded(children: items),
      ],
    );
  }
}
