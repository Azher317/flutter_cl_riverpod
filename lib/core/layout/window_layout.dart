import 'dart:math' as math;

import 'package:app/core/utils/constants/sizes.dart';
import 'package:flutter/widgets.dart';

/// Opt-in tablet layer: every phone-or-tablet decision comes from the
/// **window width**, never the device type, so an iPad in narrow Split View
/// lays out as a phone. Read it as `context.window`.
///
/// Phone-only apps don't have this folder (`bin/new_app.sh` removes it when
/// asked "Tablets? n") and use [Insets.screen] directly.
@immutable
class WindowLayout {
  const WindowLayout(this.width);

  /// The window's width in logical pixels.
  final double width;

  /// From [Layout.tabletBreakpoint] up: the side rail, the wider margin.
  bool get isTablet => width >= Layout.tabletBreakpoint;

  /// From [Layout.twoPaneMinWidth] up: [TwoPane] splits.
  bool get twoPane => width >= Layout.twoPaneMinWidth;

  /// The side margin: [Insets.screen] on a phone, [Insets.screenTablet] on a
  /// tablet (both orientations).
  double get screenInset => isTablet ? Insets.screenTablet : Insets.screen;

  /// Grid columns for [contentWidth]: [phoneColumns] on a phone; on a tablet
  /// as many [minItemWidth] items as fit with [gutter] between them.
  int columns(
    double contentWidth, {
    required double minItemWidth,
    int phoneColumns = 1,
    double gutter = Insets.medium,
  }) => isTablet
      ? math.max(
          phoneColumns,
          ((contentWidth + gutter) / (minItemWidth + gutter)).floor(),
        )
      : phoneColumns;
}

extension WindowLayoutX on BuildContext {
  WindowLayout get window => WindowLayout(MediaQuery.sizeOf(this).width);

  /// The side margin for this window ([WindowLayout.screenInset]).
  double get screenInset => window.screenInset;
}
