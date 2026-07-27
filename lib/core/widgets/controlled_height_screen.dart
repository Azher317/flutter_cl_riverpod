import 'package:flutter/material.dart';

class ControlledHeightScreen extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const ControlledHeightScreen({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,

        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight - padding.vertical,
          ),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
