import 'package:app/core/session/session_controller.dart';
import 'package:dio/dio.dart';

class Authenticator extends Interceptor {
  final SessionController session;
  Authenticator(this.session);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isSignedIn = session.isSignedIn;
    final token = session.token;

    if (isSignedIn) options.headers["Authorization"] = "Bearer $token";

    super.onRequest(options, handler);
  }
}
