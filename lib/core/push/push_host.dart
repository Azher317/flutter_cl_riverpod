import 'package:app/core/push/push_providers.dart';
import 'package:app/core/utils/constants/route_names.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Starts the push plumbing ([PushController]) and hands a tapped
/// notification's route to the router, which `core/` can't import: [open]
/// is given by app.dart. A tap during the splash waits until the router has
/// left it (and the redirect has run, so a signed-out user lands on login
/// first). Never asks for the notification permission.
class PushHost extends ConsumerStatefulWidget {
  const PushHost({
    super.key,
    required this.routeChanges,
    required this.location,
    required this.open,
    required this.child,
  });

  final Listenable routeChanges;
  final String Function() location;
  final void Function(String route) open;
  final Widget child;

  @override
  ConsumerState<PushHost> createState() => _PushHostState();
}

class _PushHostState extends ConsumerState<PushHost> {
  @override
  void initState() {
    super.initState();
    widget.routeChanges.addListener(_flush);
    ref.listenManual(pendingPushRouteProvider, (_, _) => _flush());
  }

  @override
  void dispose() {
    widget.routeChanges.removeListener(_flush);
    super.dispose();
  }

  void _flush() {
    if (widget.location() == RouteNames.splash) return;
    if (ref.read(pendingPushRouteProvider) == null) return;
    final route = ref.read(pendingPushRouteProvider.notifier).take();
    if (route != null) widget.open(route);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(pushControllerProvider);
    return widget.child;
  }
}
