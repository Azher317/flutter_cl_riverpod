import 'dart:convert';

import 'package:app/core/config/debug_tools.dart';
import 'package:app/core/network/redact.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/observability/console_printer.dart';
import 'package:dio/dio.dart';

/// Prints one console line per HTTP call (debug and UAT builds only):
///
/// ```text
/// 23:41:09 HTTP  POST /api/user/auth/login  200  66ms
/// ```
///
/// Failed calls (4xx, 5xx, no response) add the masked request and response
/// bodies under the line. With `--dart-define=LOG_BODIES=true` ([logAllBodies])
/// every call does. Headers never print. Nothing is kept in memory.
class NetworkLogger extends Interceptor {
  NetworkLogger({
    this.printAllBodies = logAllBodies,
    this.maxBodyLength = 2000,
  });

  /// Print bodies for successful calls too.
  final bool printAllBodies;

  /// A body longer than this is cut, with a note of how much was left out.
  final int maxBodyLength;

  static const _startKey = 'network_logger_start';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now().microsecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final status = response.statusCode ?? 0;
    final failed = status >= 400;
    _log(
      response.requestOptions,
      result: '$status',
      responseData: response.data,
      withBodies: failed || printAllBodies,
      failed: failed,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    _log(
      err.requestOptions,
      result: response?.statusCode?.toString() ?? err.type.name,
      responseData: response?.data,
      note: response == null ? err.message : null,
      withBodies: true,
      failed: true,
    );
    handler.next(err);
  }

  void _log(
    RequestOptions options, {
    required String result,
    required Object? responseData,
    required bool withBodies,
    required bool failed,
    String? note,
  }) {
    final start = options.extra[_startKey];
    final ms = start is int
        ? (DateTime.now().microsecondsSinceEpoch - start) ~/ 1000
        : null;

    final text = StringBuffer(
      '${options.method.padRight(4)} ${redactPathAndQuery(options.uri)}'
      '  $result${ms == null ? '' : '  ${ms}ms'}',
    );
    if (note != null && note.isNotEmpty) text.write('  $note');
    if (withBodies) {
      if (options.data != null) {
        text.write('\n  request:  ${_body(options.data)}');
      }
      if (responseData != null) {
        text.write('\n  response: ${_body(responseData)}');
      }
    }
    AppLogger.network(
      text.toString(),
      failed: failed,
      status: result,
      statusColor: _colorFor(result),
    );
  }

  /// 2xx/3xx green, 4xx red, 5xx orange, no response (timeout, offline) red.
  static ConsoleColor _colorFor(String result) {
    final status = int.tryParse(result);
    if (status == null) return ConsoleColor.red;
    if (status >= 500) return ConsoleColor.orange;
    if (status >= 400) return ConsoleColor.red;
    return ConsoleColor.green;
  }

  String _body(Object? data) {
    final redacted = redactBody(data);
    String text;
    try {
      text = redacted is String ? redacted : jsonEncode(redacted);
    } on Object {
      text = redacted.toString();
    }
    text = text.replaceAll('\n', ' ');
    if (text.length <= maxBodyLength) return text;
    final left = text.length - maxBodyLength;
    return '${text.substring(0, maxBodyLength)}… ($left more characters)';
  }
}
