import 'dart:convert';
import 'dart:typed_data';

import 'package:app/core/network/network_logger.dart';
import 'package:app/core/network/redact.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

class _CaptureOutput extends LogOutput {
  final lines = <String>[];

  @override
  void output(OutputEvent event) => lines.addAll(event.lines);
}

/// Answers every call with [status] and [body], or fails with no response.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({this.status = 200, this.body = const {}, this.offline = false});

  final int status;
  final Object body;
  final bool offline;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (offline) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'No route to host',
      );
    }
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_FakeAdapter adapter, {bool printAllBodies = false}) =>
    Dio(BaseOptions(baseUrl: 'https://uat.example.com'))
      ..httpClientAdapter = adapter
      ..interceptors.add(NetworkLogger(printAllBodies: printAllBodies));

const _login = {'phoneNumber': '07700000000', 'password': 'pw123'};
const _token = {
  'data': {'token': 'tok-123', 'name': 'Azher'},
};

void main() {
  late _CaptureOutput console;

  setUp(() {
    console = _CaptureOutput();
    AppLogger.useConsoleOutput(console);
  });

  tearDown(() => AppLogger.useConsoleOutput(null));

  String printed() => console.lines.join('\n');

  test('a successful call prints one line with no body', () async {
    await _dio(
      _FakeAdapter(body: _token),
    ).post<Object?>('/api/user/auth/login', data: _login);

    expect(console.lines, hasLength(1));
    expect(
      console.lines.single,
      matches(RegExp(r'HTTP  POST /api/user/auth/login  200  \d+ms$')),
    );
  });

  test('a failed call prints both bodies, masked', () async {
    final dio = _dio(
      _FakeAdapter(status: 500, body: {'message': 'Internal Server Error'}),
    );

    await expectLater(
      dio.post<Object?>('/api/user/auth/login', data: _login),
      throwsA(isA<DioException>()),
    );

    expect(console.lines.first, contains('POST /api/user/auth/login  500'));
    expect(printed(), contains('request:  {"phoneNumber":"$hiddenValue"'));
    expect(
      printed(),
      contains('response: {"message":"Internal Server Error"}'),
    );
    expect(printed(), isNot(contains('pw123')));
    expect(printed(), isNot(contains('07700000000')));
  });

  test('LOG_BODIES prints the bodies of successful calls too', () async {
    await _dio(
      _FakeAdapter(body: _token),
      printAllBodies: true,
    ).post<Object?>('/api/user/auth/login', data: _login);

    expect(printed(), contains('response: {"data":{"token":"$hiddenValue"'));
    expect(printed(), isNot(contains('tok-123')));
  });

  test('a call with no response prints the error type and request', () async {
    final dio = _dio(_FakeAdapter(offline: true));

    await expectLater(
      dio.post<Object?>('/api/user/auth/login', data: _login),
      throwsA(isA<DioException>()),
    );

    expect(console.lines.first, contains('POST /api/user/auth/login  '));
    expect(console.lines.first, contains('connectionError'));
    expect(printed(), contains('request:  '));
  });

  test('a long body is cut with a note', () async {
    await _dio(
      _FakeAdapter(body: {'list': 'x' * 5000}),
      printAllBodies: true,
    ).get<Object?>('/api/list');

    expect(printed(), contains('more characters)'));
    expect(printed().length, lessThan(2500));
  });
}
