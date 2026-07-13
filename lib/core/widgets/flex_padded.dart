import 'package:flutter/material.dart';

class ColumnPadded extends Column {
  ColumnPadded({
    super.key,
    double gap = 8,
    required List<Widget> children,
    super.crossAxisAlignment,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
  }) : super(
         children: [
           for (var i = 0; i < children.length; i++) ...[
             children[i],
             if (i != children.length - 1) SizedBox(height: gap),
           ],
         ],
       );
}

class RowPadded extends Row {
  RowPadded({
    super.key,
    double gap = 8,
    required List<Widget> children,
    super.crossAxisAlignment,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
  }) : super(
         children: [
           for (var i = 0; i < children.length; i++) ...[
             children[i],
             if (i != children.length - 1) SizedBox(width: gap),
           ],
         ],
       );
}

class FlexPadded extends Flex {
  FlexPadded({
    super.key,
    double gap = 8,
    required super.direction,
    required List<Widget> children,
    super.crossAxisAlignment,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
  }) : super(
         children: [
           for (var i = 0; i < children.length; i++) ...[
             children[i],
             if (i != children.length - 1)
               SizedBox(
                 width: direction == Axis.horizontal ? gap : null,
                 height: direction == Axis.vertical ? gap : null,
               ),
           ],
         ],
       );
}
