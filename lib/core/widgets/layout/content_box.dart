import 'dart:math' as math;

import 'package:app/core/layout/window_layout.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:flutter/widgets.dart';

/// The one source of a screen's outer side padding. It caps the content at
/// [maxWidth] by padding, not by centring a narrower box, so a scroll view
/// keeps the full width (pull-to-refresh and the scrollbar stay at the
/// edge). [builder] gets that padding to put on its list, grid or column;
/// widgets inside never add the screen margin again.
///
/// On a phone every cap is wider than the window, so the padding is the
/// phone margin (16), as before.
class ContentBox extends StatelessWidget {
  const ContentBox({
    super.key,
    this.maxWidth = Layout.contentMaxWidth,
    required this.builder,
  });

  /// [Layout.contentMaxWidth] or [Layout.singleColumnMaxWidth].
  final double maxWidth;

  final Widget Function(BuildContext context, EdgeInsets padding) builder;

  /// The side padding for [available] width: the window's margin, or more
  /// when the content would grow past [maxWidth].
  static double sidePadding(
    double available, {
    required double inset,
    double maxWidth = Layout.contentMaxWidth,
  }) => math.max(inset, (available - maxWidth) / 2);

  @override
  Widget build(BuildContext context) {
    final inset = context.screenInset;
    return LayoutBuilder(
      builder: (context, constraints) => builder(
        context,
        EdgeInsets.symmetric(
          horizontal: sidePadding(
            constraints.maxWidth,
            inset: inset,
            maxWidth: maxWidth,
          ),
        ),
      ),
    );
  }
}
