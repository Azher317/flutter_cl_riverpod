import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:flutter/material.dart';

/// List items (or a screen's sections) fading and sliding in one after
/// another: opacity 0 → 1 and translateY 8 → 0 over [Time.stagger] ×
/// [index] delay (capped at [maxStagger]), [Time.enter], [Motion.standard].
///
/// Wrap each item of a list that just loaded: `StaggeredEnter(index: i,
/// child: tile)`. Only on first appearance, never on every rebuild or for
/// pagination pages after the first. Reduced motion: every item appears
/// together, no offset.
class StaggeredEnter extends StatefulWidget {
  const StaggeredEnter({
    super.key,
    this.index = 0,
    this.delay = Duration.zero,
    required this.child,
  });

  /// Position in the list; drives the delay.
  final int index;

  /// Waits this long before the first item (e.g. until a sheet has risen).
  final Duration delay;
  final Widget child;

  /// Items after this one don't wait any longer, so long lists don't lag.
  static const int maxStagger = 8;

  @override
  State<StaggeredEnter> createState() => _StaggeredEnterState();
}

class _StaggeredEnterState extends State<StaggeredEnter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Time.enter,
  );
  late final CurvedAnimation _progress = CurvedAnimation(
    parent: _controller,
    curve: Motion.standard,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.reduceMotion) {
        _controller.value = 1;
        return;
      }
      final steps = widget.index.clamp(0, StaggeredEnter.maxStagger);
      Future<void>.delayed(widget.delay + Time.stagger * steps, () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _progress.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _progress,
    builder: (context, child) => Opacity(
      opacity: _progress.value,
      child: Transform.translate(
        offset: Offset(0, Insets.small * (1 - _progress.value)),
        child: child,
      ),
    ),
    child: widget.child,
  );
}
