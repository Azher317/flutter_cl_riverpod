import 'package:app/core/session/session_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bridges [sessionProvider] to go_router's `refreshListenable`.
///
/// Whenever the session state changes (sign in / sign out / cache restore),
/// this notifies listeners so the router re-evaluates its `redirect`.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    _sub = ref.listen(
      sessionProvider,
      (_, _) => notifyListeners(),
    );
  }

  late final ProviderSubscription _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
