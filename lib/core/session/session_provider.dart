import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/session/session_controller.dart';

part 'session_provider.g.dart';

@Riverpod(keepAlive: true)
SessionController sessionController(Ref ref) => throw UnimplementedError(
  'Override sessionControllerProvider with a feature-specific implementation',
);
