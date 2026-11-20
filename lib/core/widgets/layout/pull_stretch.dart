import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A header at the top of a scroll view whose [background] stretches up
/// into the gap when the page is pulled down (iOS bounce), so the space
/// above it never shows a white strip. A photo background (BoxFit.cover)
/// zooms; a pattern simply fills. [child] (the header's content) stays put.
///
/// Put it as the first item of a ListView, or the first box of a
/// CustomScrollView. [background] must fill its box.
class PullStretch extends StatelessWidget {
  const PullStretch({super.key, required this.background, required this.child});

  final Widget background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final position = Scrollable.maybeOf(context)?.position;
    if (position == null) {
      return Stack(
        children: [
          Positioned.fill(child: background),
          child,
        ],
      );
    }
    return AnimatedBuilder(
      animation: position,
      child: child,
      builder: (context, child) {
        // How far past the top the page is pulled (0 when not pulled).
        final pull = position.hasPixels && position.hasContentDimensions
            ? math.max(0.0, position.minScrollExtent - position.pixels)
            : 0.0;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -pull,
              left: 0,
              right: 0,
              bottom: 0,
              child: background,
            ),
            child!,
          ],
        );
      },
    );
  }
}
