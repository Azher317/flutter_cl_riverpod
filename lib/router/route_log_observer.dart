import 'package:app/core/observability/app_logger.dart';
import 'package:flutter/widgets.dart';

/// Prints screen changes to the console (debug and UAT builds only):
/// `ROUTE Open /login`, `ROUTE Back to /`.
///
/// Only named routes print: screens are named by `appPage`; dialogs and
/// sheets have no name and are skipped.
class RouteLogObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = route.settings.name;
    if (name != null) AppLogger.route('Open $name');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = previousRoute?.settings.name;
    if (route.settings.name != null && name != null) {
      AppLogger.route('Back to $name');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final name = newRoute?.settings.name;
    if (name != null) AppLogger.route('Open $name');
  }
}
