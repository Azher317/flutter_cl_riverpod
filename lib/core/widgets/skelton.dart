import 'package:app/core/constants/sizes.dart';
import 'package:flutter/material.dart';

/// Shared shimmer sweep logic for skeleton placeholders: one
/// [AnimationController] per widget, theme-driven colors, wrapped in a
/// [RepaintBoundary] so the sweep doesn't repaint sibling widgets.
mixin _ShimmerSweep<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late final AnimationController shimmerController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    shimmerController.dispose();
    super.dispose();
  }

  Widget buildShimmer(BuildContext context, Widget child) {
    final scheme = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: shimmerController,
        builder: (context, shaderChild) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final v = shimmerController.value;
            return LinearGradient(
              begin: Alignment(-1 - 2 * v, 0),
              end: Alignment(1 - 2 * v, 0),
              colors: [
                scheme.surfaceContainerHighest,
                scheme.surfaceContainerLow,
                scheme.surfaceContainerHighest,
              ],
              stops: const [0.1, 0.5, 0.9],
            ).createShader(bounds);
          },
          child: shaderChild,
        ),
        child: child,
      ),
    );
  }
}

class CustomSkeleton extends StatefulWidget {
  const CustomSkeleton({
    super.key,
    this.height,
    this.width,
    this.radius = BorderSize.small,
  });

  final double? height, width;
  final double radius;

  @override
  State<CustomSkeleton> createState() => _CustomSkeletonState();
}

class _CustomSkeletonState extends State<CustomSkeleton>
    with SingleTickerProviderStateMixin, _ShimmerSweep {
  @override
  Widget build(BuildContext context) {
    return buildShimmer(
      context,
      Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

class CircleSkeleton extends StatefulWidget {
  const CircleSkeleton({super.key, this.size = 24});

  final double? size;

  @override
  State<CircleSkeleton> createState() => _CircleSkeletonState();
}

class _CircleSkeletonState extends State<CircleSkeleton>
    with SingleTickerProviderStateMixin, _ShimmerSweep {
  @override
  Widget build(BuildContext context) {
    return buildShimmer(
      context,
      Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
