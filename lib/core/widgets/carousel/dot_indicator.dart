import 'package:flutter/material.dart';
import 'package:app/core/theme/sizes.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Time.small,
      height: 6,
      width: isActive ? 35 : 6,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant,
        borderRadius: const BorderRadius.all(Radius.circular(Insets.large)),
      ),
    );
  }
}
