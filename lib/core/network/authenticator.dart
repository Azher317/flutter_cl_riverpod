import 'package:app/core/network/api_headers.dart';
import 'package:app/core/session/session_controller.dart';
import 'package:dio/dio.dart';

class Authenticator extends Interceptor {
  final SessionController session;
  Authenticator(this.session);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isSignedIn = session.isSignedIn;
    final token = session.token;

    if (isSignedIn) {
      options.headers[ApiHeaders.authorization] = '${ApiHeaders.bearer} $token';
    }

    super.onRequest(options, handler);
  }
}
