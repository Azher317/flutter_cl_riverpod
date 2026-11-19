import 'dart:math' as math;

import 'package:app/core/layout/window_layout.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/widgets/layout/content_box.dart';
import 'package:flutter/widgets.dart';

/// Two panes side by side from [Layout.twoPaneMinWidth] (list and details,
/// a form and its summary): [start] takes what's left, [end] is [endWidth]
/// wide, or half the content but at least [endMinWidth]. Both sit in the
/// [Layout.contentMaxWidth] cap with [Insets.screenTablet] between them,
/// and stretch to the full height, so each pane scrolls on its own.
///
/// Below 720 only [start] shows, full width with no padding: the screen lays
/// its phone page out inside it (the end content goes in [start], its phone
/// way). The tree is the same either way (a [Row] with the start pane first),
/// so [start] keeps its state when the window crosses 720.
class TwoPane extends StatelessWidget {
  const TwoPane({
    super.key,
    required this.start,
    required this.end,
    this.endWidth,
    this.endMinWidth,
  }) : assert(
         (endWidth == null) != (endMinWidth == null),
         'Give endWidth or endMinWidth',
       );

  final Widget start;
  final Widget end;

  /// A fixed end pane width.
  final double? endWidth;

  /// An end pane of half the content, never under this.
  final double? endMinWidth;

  /// The end pane's width for [content] (the capped width between the
  /// side margins).
  @visibleForTesting
  static double endPaneWidth(
    double content, {
    double? endWidth,
    double? endMinWidth,
  }) => endWidth ?? math.max(endMinWidth!, (content - Insets.screenTablet) / 2);

  @override
  Widget build(BuildContext context) {
    final split = context.window.twoPane;
    return ContentBox(
      builder: (context, padding) => Padding(
        padding: split ? padding : EdgeInsets.zero,
        child: LayoutBuilder(
          builder: (context, box) => Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: start),
              if (split) ...[
                const SizedBox(width: Insets.screenTablet),
                SizedBox(
                  width: endPaneWidth(
                    box.maxWidth,
                    endWidth: endWidth,
                    endMinWidth: endMinWidth,
                  ),
                  child: end,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A footer for [TwoPane]'s end pane, for `Scaffold.bottomNavigationBar`: it
/// lines up with the pane and takes only its child's height. Being the
/// scaffold's bottom bar, not part of the pane, it keeps snackbars above it.
class TwoPaneFooter extends StatelessWidget {
  const TwoPaneFooter({
    super.key,
    required this.child,
    required this.endMinWidth,
  });

  final Widget child;

  /// The same as the [TwoPane]'s [TwoPane.endMinWidth].
  final double endMinWidth;

  @override
  Widget build(BuildContext context) => ContentBox(
    builder: (context, padding) => Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, box) => Align(
          alignment: AlignmentDirectional.centerEnd,
          heightFactor: 1,
          child: SizedBox(
            width: TwoPane.endPaneWidth(box.maxWidth, endMinWidth: endMinWidth),
            child: child,
          ),
        ),
      ),
    ),
  );
}
