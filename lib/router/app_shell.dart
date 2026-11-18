import 'package:app/core/feedback/app_haptics.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// OPT-IN: only for apps with a bottom navigation bar. Not wired by default;
/// the router snippet that turns it on is in .claude/rules/routing.md
/// ("Bottom navigation (opt-in)").
///
/// The tab shell for a `StatefulShellRoute`: each tab is a branch that keeps
/// its own history and state. Phones show a Material [NavigationBar];
/// windows from [Layout.tabletBreakpoint] up show a [NavigationRail] at the
/// start edge instead. Switching tabs fades the incoming tab in
/// ([Time.small]; instant with reduced motion) and plays a `selection`
/// haptic. Tapping the current tab again returns it to its first page.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.shell,
    required this.children,
    required this.destinations,
  });

  final StatefulNavigationShell shell;

  /// One per branch, in branch order (from `navigatorContainerBuilder`).
  final List<Widget> children;

  /// One per branch, in branch order. Labels come from `context.l10n`.
  final List<NavigationDestination> destinations;

  void _select(int index) {
    if (index != shell.currentIndex) AppHaptics.selection();
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _FadingTabs(index: shell.currentIndex, children: children);
    if (context.width >= Layout.tabletBreakpoint) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _select,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon,
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: tabs),
          ],
        ),
      );
    }
    return Scaffold(
      body: tabs,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _select,
        destinations: destinations,
      ),
    );
  }
}

class _FadingTabs extends StatefulWidget {
  const _FadingTabs({required this.index, required this.children});

  final int index;
  final List<Widget> children;

  @override
  State<_FadingTabs> createState() => _FadingTabsState();
}

class _FadingTabsState extends State<_FadingTabs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: Time.small,
    value: 1,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _fade,
    curve: Motion.standard,
  );

  @override
  void didUpdateWidget(_FadingTabs old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      if (context.reduceMotion) {
        _fade.value = 1;
      } else {
        _fade.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      for (var i = 0; i < widget.children.length; i++)
        Offstage(
          offstage: i != widget.index,
          child: TickerMode(
            enabled: i == widget.index,
            // Same tree shape for every tab at all times, so a branch never
            // remounts (and loses its state) when it becomes current.
            child: FadeTransition(
              opacity: i == widget.index ? _opacity : kAlwaysCompleteAnimation,
              child: widget.children[i],
            ),
          ),
        ),
    ],
  );
}
