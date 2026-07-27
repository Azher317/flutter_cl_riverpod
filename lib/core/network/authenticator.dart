import 'package:app/core/network/api_headers.dart';
import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/session/session_notifier.dart';

/// Attaches the bearer token to every request. Reads the current token from
/// the core [sessionProvider] at request time — the network layer is allowed
/// to see the token; UI is not (it uses `SessionController`, which has none).
class Authenticator extends Interceptor {
  final Ref _ref;
  Authenticator(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(sessionProvider).value?.token;

    if (token != null) {
      options.headers[ApiHeaders.authorization] = '${ApiHeaders.bearer} $token';
    }

    super.onRequest(options, handler);
  }
}
