import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:flutter/material.dart';

/// A field's error shake (phone, code, forms): translateX
/// 0 → −8 → 8 → −5 → 5 → 0 over [Time.shake], [Motion.standard]. Mirrors in
/// RTL so the first nudge goes toward the start.
///
/// Bump [trigger] (e.g. an error counter) to play it once. Under reduced
/// motion it never moves — the red border and message carry the error alone.
class FieldShake extends StatefulWidget {
  const FieldShake({super.key, required this.trigger, required this.child});

  /// Each change to a new non-zero value plays the shake once.
  final int trigger;
  final Widget child;

  static final Animatable<double> _offset = TweenSequence<double>([
    for (final (a, b) in const [
      (0.0, -Insets.small),
      (-Insets.small, Insets.small),
      (Insets.small, -5.0),
      (-5.0, 5.0),
      (5.0, 0.0),
    ])
      TweenSequenceItem(
        tween: Tween(begin: a, end: b),
        weight: 1,
      ),
  ]).chain(CurveTween(curve: Motion.standard));

  @override
  State<FieldShake> createState() => _FieldShakeState();
}

class _FieldShakeState extends State<FieldShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Time.shake,
  );

  @override
  void didUpdateWidget(FieldShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger &&
        widget.trigger != 0 &&
        !context.reduceMotion) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sign = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(sign * FieldShake._offset.evaluate(_controller), 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}
