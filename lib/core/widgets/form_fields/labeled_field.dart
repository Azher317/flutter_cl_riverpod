import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.items});

  final String label;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(Insets.medium),
        Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              items[i],
              if (i < items.length - 1) Gap(Insets.medium),
            ],
          ],
        ),
      ],
    );
  }
}
