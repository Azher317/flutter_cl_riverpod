import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// The one loading look: while [enabled], [child] is drawn as grey bones
/// shimmering between `surfaceContainerHigh` and `surfaceContainerHighest`
/// (a flat fill with reduced motion), hidden from screen readers and taps.
///
/// **Build the skeleton from the real widgets**, fed placeholder data, so it
/// has exactly the shape the screen will have when data arrives:
///
/// ```dart
/// final orders = ref.watch(ordersProvider);
/// return AppSkeleton(
///   enabled: orders.isLoading && !orders.hasValue,
///   child: OrdersList(orders: orders.value ?? OrderEntity.placeholders(6)),
/// );
/// ```
///
/// Rules: .claude/rules/presentation.md ("Loading states").
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({super.key, required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Skeletonizer(
      enabled: enabled,
      effect: context.reduceMotion
          ? SolidColorEffect(color: scheme.surfaceContainerHigh)
          : ShimmerEffect(
              baseColor: scheme.surfaceContainerHigh,
              highlightColor: scheme.surfaceContainerHighest,
              duration: Time.shimmer,
            ),
      // Bones are not content: screen readers skip them.
      child: ExcludeSemantics(excluding: enabled, child: child),
    );
  }
}
