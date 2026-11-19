import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:flutter/material.dart';

/// The body under a tab bar. A tab is built only the first time it is chosen
/// (so its data loads only then) and then stays alive while the screen is
/// open. Switching slides the new tab in from the side of the tab you moved
/// toward and the old one out the other way (mirrored in RTL). Instant
/// under reduced motion.
///
/// Sized to the current tab, so it works inside a scrolling column.
class TabSwitcher extends StatefulWidget {
  const TabSwitcher({
    super.key,
    required this.index,
    required this.count,
    required this.builder,
  });

  final int index;
  final int count;
  final IndexedWidgetBuilder builder;

  @override
  State<TabSwitcher> createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher>
    with SingleTickerProviderStateMixin {
  late final Set<int> _built = {widget.index};
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Time.enter,
    value: 1,
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Motion.emphasizedDecelerate,
  );
  int? _from;

  @override
  void didUpdateWidget(TabSwitcher old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _built.add(widget.index);
      if (context.reduceMotion) {
        _from = null;
        _c.value = 1;
      } else {
        _from = old.index;
        _c.forward(from: 0).whenComplete(() {
          if (mounted) setState(() => _from = null);
        });
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final from = _from;
    // Moving to a later tab: the new one comes from the reading end.
    final forward = from == null || widget.index > from;
    final sign = (forward ? 1.0 : -1.0) * (rtl ? -1 : 1);
    return ClipRect(
      child: AnimatedBuilder(
        animation: _t,
        builder: (context, _) => Stack(
          children: [
            for (final i in _built.toList()..sort())
              _slot(
                i,
                visible: i == widget.index || i == from,
                dx: i == widget.index
                    ? sign * (1 - _t.value)
                    : i == from
                    ? -sign * _t.value
                    : 0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _slot(int i, {required bool visible, required double dx}) {
    // The same tree shape for a tab at all times, so it keeps its state.
    // Hidden tabs are offstage (zero size), so the stack takes the current
    // tab's height (the larger of the two while sliding).
    return Offstage(
      offstage: !visible,
      child: TickerMode(
        enabled: visible,
        child: FractionalTranslation(
          translation: Offset(dx, 0),
          child: KeyedSubtree(
            key: ValueKey(i),
            child: widget.builder(context, i),
          ),
        ),
      ),
    );
  }
}
