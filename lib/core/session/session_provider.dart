import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/session/session_controller.dart';
import 'package:app/core/session/session_notifier.dart';

part 'session_provider.g.dart';

/// UI-facing view of the session: the user, auth-status and logout — never the
/// token. Delegates to the core [Session] notifier ([sessionProvider]). The
/// network layer reads the token from `sessionProvider` directly instead.
@Riverpod(keepAlive: true)
SessionController sessionController(Ref ref) =>
    ref.watch(sessionProvider.notifier);
