import 'dart:async';
import 'package:app/core/config/debug_tools.dart';
import 'package:app/core/network/api_document.dart';
import 'package:app/core/network/api_headers.dart';
import 'package:app/core/network/authenticator.dart';
import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

part 'dio_module.g.dart';

// keepAlive: App-lifetime service: Dio.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio();

  Completer<void>? pendingLogout;

  dio
    ..options.baseUrl = ApiDocument.baseUrl
    ..options.connectTimeout = const Duration(seconds: 30)
    ..options.sendTimeout = const Duration(seconds: 60)
    ..options.receiveTimeout = const Duration(seconds: 60)
    ..options.headers = {
      ApiHeaders.accept: ApiHeaders.applicationJson,
      ApiHeaders.contentType: ApiHeaders.applicationJson,
    }
    ..interceptors.add(Authenticator(ref))
    ..interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          final skipAuthLogout =
              e.requestOptions.extra['skipAuthLogout'] == true;
          if (e.response?.statusCode == 401 && !skipAuthLogout) {
            if (pendingLogout == null) {
              pendingLogout = Completer<void>();
              try {
                await ref.read(sessionProvider.notifier).logout();
              } finally {
                pendingLogout!.complete();
                pendingLogout = null;
              }
            } else {
              await pendingLogout!.future;
            }
          }

          if (!showDebugTools) {
            // Debug and UAT already log every failure through
            // TalkerDioLogger; prod has no console, so report instead.
            if (e.type == DioExceptionType.cancel) {
              AppLogger.warning(e.message ?? 'Request cancelled');
            } else {
              AppLogger.handle(e, e.stackTrace);
            }
          }
          handler.next(e);
        },
      ),
    );

  if (showDebugTools) {
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        // Console: method, URL, status, time, request body, error body.
        // Response bodies are kept for the logs screen and cut from the
        // console (app_logger.dart).
        // Request and response headers are off by default; error headers
        // are turned off here.
        settings: const TalkerDioLoggerSettings(
          printErrorHeaders: false,
          printResponseTime: true,
          hiddenHeaders: {'authorization', 'cookie', 'set-cookie'},
          hiddenBodyKeys: {
            'password',
            'token',
            'accessToken',
            'access_token',
            'refreshToken',
            'refresh_token',
            'otp',
            'pin',
            'secret',
            'newPassword',
            'oldPassword',
            'confirmPassword',
            'phone',
            'phoneCountryCode',
            'email',
          },
        ),
      ),
    );
  }

  ref.onDispose(() => dio.close(force: true));

  return dio;
}

extension DioRefX on Ref {
  Dio get dio => read(dioProvider);
}
