import 'dart:async';
import 'package:app/core/network/api_document.dart';
import 'package:app/core/network/api_headers.dart';
import 'package:app/core/network/authenticator.dart';
import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/session/session_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

part 'dio_module.g.dart';

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
    ..interceptors.add(Authenticator(ref.read(sessionControllerProvider)))
    ..interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          final skipAuthLogout =
              e.requestOptions.extra['skipAuthLogout'] == true;
          if (e.response?.statusCode == 401 && !skipAuthLogout) {
            if (pendingLogout == null) {
              pendingLogout = Completer<void>();
              try {
                await ref.read(sessionControllerProvider).logout();
              } finally {
                pendingLogout!.complete();
                pendingLogout = null;
              }
            } else {
              await pendingLogout!.future;
            }
          }

          if (!kDebugMode) {
            if (e.type == DioExceptionType.cancel) {
              talker.warning(e.message ?? 'Request cancelled');
            } else {
              talker.handle(e, e.stackTrace);
            }
          }
          handler.next(e);
        },
      ),
    );

  if (kDebugMode) {
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
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
