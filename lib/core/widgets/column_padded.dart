import 'package:app/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ColumnPadded extends StatelessWidget {
  const ColumnPadded({
    super.key,
    required this.children,
    this.spacing = Insets.medium,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  });
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: children,
    );
  }
}
