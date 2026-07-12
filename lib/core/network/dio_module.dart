import 'dart:async';

import 'package:app/core/network/api_document.dart';
import 'package:app/core/network/api_headers.dart';
import 'package:app/core/network/authenticator.dart';
import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/session/session_provider.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:flutter/foundation.dart';

part 'dio_module.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio();

  // Guards concurrent 401s so N simultaneous requests trigger exactly one
  // logout instead of N redundant ones. This is *not* a refresh-token flow —
  // there's no /auth/refresh endpoint in this app yet, so a 401 still ends
  // the session rather than silently re-authenticating. Once a refresh
  // endpoint exists, this is the seam to extend: race the first 401 into a
  // real refresh call, complete [_pendingLogout] with the outcome, and only
  // fall through to logout() if the refresh itself fails.
  Completer<void>? pendingLogout;

  dio
    ..options.baseUrl = ApiDocument.baseUrl
    ..options.connectTimeout = const Duration(seconds: 30)
    ..options.sendTimeout = const Duration(seconds: 60)
    ..options.receiveTimeout = const Duration(seconds: 60)
    ..options.contentType = '${ApiHeaders.applicationJson}; charset=utf-8'
    ..options.headers = {
      ApiHeaders.accept: "text/plain",
      ApiHeaders.contentType: ApiHeaders.applicationJson,
    }
    ..interceptors.add(Authenticator(ref.read(sessionControllerProvider)))
    ..interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          final skipAuthLogout = e.requestOptions.extra['skipAuthLogout'] == true;
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
          switch (e.type) {
            case DioExceptionType.badCertificate:
              break;
            case DioExceptionType.badResponse:
              debugPrint(e.error.toString());
              break;
            case DioExceptionType.cancel:
              debugPrint(e.message);
              break;
            case DioExceptionType.connectionError:
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.transformTimeout:
              break;
            case DioExceptionType.unknown:
              // Not shown to the user directly — the data layer maps this
              // into a typed exception/Failure, and the UI resolves the
              // display string via l10n (see login_screen.dart).
              String message = "Unknown error";
              if (e.error is FormatException) {
                message = e.error
                    .toString()
                    .replaceRange(0, 54, "")
                    .replaceAll("^", "");
              } else {
                final data = e.response?.data;
                if (data is Map<String, dynamic>) {
                  message = data['message'] ?? message;
                } else if (data is String) {
                  message = data;
                }
              }
              final parsedResponse = Response(
                requestOptions: e.requestOptions,
                data: {"data": {}, "message": message, "statusCode": 400},
                statusMessage: e.message,
              );
              handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  response: parsedResponse,
                  error: message,
                  type: DioExceptionType.unknown,
                ),
              );
              return; // add this line to prevent calling handler.next(e)
          }
          handler.next(e);
        },
      ),
    );

  if (kDebugMode) dio.interceptors.add(AwesomeDioInterceptor());

  return dio;
}

extension DioRefX on Ref {
  Dio get dio => read(dioProvider);
}
