import 'dart:convert';

import 'package:app/core/network/api_document.dart';
import 'package:app/core/network/authenticator.dart';
import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/session/session_provider.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:flutter/foundation.dart';

part 'dio_module.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio();
  dio
    ..options.baseUrl = ApiDocument.baseUrl
    ..options.connectTimeout = const Duration(seconds: 30)
    ..options.sendTimeout = const Duration(seconds: 60)
    ..options.contentType = 'application/json; charset=utf-8'
    ..options.headers = {
      "accept": "text/plain",
      "Content-Type": "application/json",
    }
    ..interceptors.add(Authenticator(ref.read(sessionControllerProvider)))
    ..interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          final skipAuthLogout = e.requestOptions.extra['skipAuthLogout'] == true;
          if (e.response?.statusCode == 401 && !skipAuthLogout) {
            await ref.read(sessionControllerProvider).logout();
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
              String message = "حدث خطأ ما";
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
                  message = json.decode(json.encode(data));
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
        onResponse: (response, handler) {
          dynamic data = response.data;
          if (response.data is List<dynamic>) {
            data = {
              "data": response.data,
              "message": response.statusMessage,
              "statusCode": response.statusCode,
            };
          }
          // else if (data is Map<String, dynamic> &&
          //     (data['data'] == null ||
          //         data['message'] == null ||
          //         data['statusCode'] == null)) {
          //   data['data'] ??= {}; // Set result to an empty object if it's null
          //   data["message"] ??= response.statusMessage;
          //   data["statusCode"] ??= response.statusCode;
          // }
          else if (response.data is String) {
            data = {
              "data": {},
              "message": response.data,
              "statusCode": response.statusCode,
            };
          }
          final modifiedResponse = Response(
            requestOptions: response.requestOptions,
            data: data,
            headers: response.headers,
            isRedirect: response.isRedirect,
            redirects: response.redirects,
            extra: response.extra,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
          );
          return handler.next(modifiedResponse);
        },
      ),
    );

  if (kDebugMode) dio.interceptors.add(AwesomeDioInterceptor());

  return dio;
}

extension DioRefX on Ref {
  Dio get dio => read(dioProvider);
}
