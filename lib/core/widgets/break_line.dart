import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class BreakLine extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final double? borderRadius;
  const BreakLine({
    super.key,
    this.width = 120,
    this.height = 3,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 3,
        width: 120,
        decoration: BoxDecoration(
          color: color ?? context.colorScheme.outlineVariant,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? BorderSize.medium),
          ),
        ),
      ),
    );
  }
}
