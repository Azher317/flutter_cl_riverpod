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

bool _isAuthPath(String path) =>
    path.contains('/auth'); // matches Endpoints.login = '/auth/login'

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
      ApiHeaders.accept: 'text/plain',
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
          switch (e.type) {
            case DioExceptionType.badCertificate:
            case DioExceptionType.badResponse:
              break;
            case DioExceptionType.cancel:
              talker.warning(e.message ?? 'Request cancelled');
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
              String message = 'Unknown error';
              if (e.error is FormatException) {
                message = e.error
                    .toString()
                    .replaceRange(0, 54, '')
                    .replaceAll('^', '');
              } else {
                final data = e.response?.data;
                if (data is Map<String, dynamic>) {
                  message = data['message'] as String;
                } else if (data is String) {
                  message = data;
                }
              }
              final parsedResponse = Response(
                requestOptions: e.requestOptions,
                data: {
                  'data': <String, dynamic>{},
                  'message': message,
                  'statusCode': 400,
                },
                statusMessage: e.message,
              );
              // handler.reject short-circuits the interceptor chain, so the
              // dio logger (added last) never sees this — log it explicitly.
              talker.handle(e, e.stackTrace);
              handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  response: parsedResponse,
                  error: message,
                ),
              );
              return; // add this line to prevent calling handler.next(e)
          }
          handler.next(e);
        },
      ),
    );

  if (kDebugMode) {
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        // Sensitive values are replaced with `*****` in request, response and
        // error logs. To hide a new value, add its key below; to see a value in
        // the clear while debugging, remove (or comment out) its key.
        //
        // `hiddenBodyKeys` matches the key as it appears in the JSON **on the
        // wire**, not the Dart field name. This app has no `field_rename` (see
        // core/annotations/json_serializable.dart), so the two happen to match
        // today — but a field carrying `@JsonKey(name: 'access_token')` must be
        // listed as `access_token`, not `accessToken`. Matching is
        // case-insensitive but not snake/camel-aware, so a wrong spelling fails
        // silently. Keys are matched at any depth, so `token` also covers the
        // `data.token` nested inside the DefaultResponse envelope.
        //
        // Keys below that aren't in the schema yet (refresh/otp/…) are listed
        // deliberately: over-masking a debug log is harmless, under-masking
        // leaks. `phoneNumber` is intentionally left visible — it's PII, not a
        // credential, and it's what makes an auth log useful.
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          hiddenHeaders: {
            'authorization', // api_headers.dart, set by Authenticator
            'cookie', 'set-cookie', // no cookie handling today; defensive
          },
          hiddenBodyKeys: {
            // In the schema today:
            'password', // LoginRequestModel
            'token', // UserModel (login response), AuthenticationModel
            // Not in the schema yet — masked pre-emptively:
            'accessToken', 'access_token',
            'refreshToken', 'refresh_token',
            'otp', 'pin', 'secret',
            'newPassword', 'oldPassword', 'confirmPassword',
          },
        ),
      ),
    );
  }

  return dio;
}

extension DioRefX on Ref {
  Dio get dio => read(dioProvider);
}
