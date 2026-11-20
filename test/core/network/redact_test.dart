import 'package:app/core/network/redact.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _LoginBody {
  const _LoginBody(this.phone, this.password);

  final String phone;
  final String password;

  Map<String, Object?> toJson() => {'phone': phone, 'password': password};
}

void main() {
  test('masks hidden keys in nested maps and lists, ignoring case', () {
    final body = {
      'Password': 'secret1',
      'name': 'Ali',
      'data': {
        'token': 'abc',
        'items': [
          {'EMAIL': 'a@b.c', 'id': 1},
        ],
      },
    };

    expect(redactBody(body), {
      'Password': hiddenValue,
      'name': 'Ali',
      'data': {
        'token': hiddenValue,
        'items': [
          {'EMAIL': hiddenValue, 'id': 1},
        ],
      },
    });
  });

  test('never changes the source', () {
    final body = {'password': 'secret1'};

    redactBody(body);

    expect(body['password'], 'secret1');
  });

  test('masks a request model through its toJson', () {
    expect(redactBody(const _LoginBody('0770', 'pw')), {
      'phone': hiddenValue,
      'password': hiddenValue,
    });
  });

  test('masks form data fields and names its files', () {
    final form = FormData.fromMap({
      'otp': '1234',
      'note': 'hi',
      'avatar': MultipartFile.fromString('x', filename: 'me.png'),
    });

    expect(redactBody(form), {
      'otp': hiddenValue,
      'note': 'hi',
      'avatar': '<file me.png>',
    });
  });

  test('leaves raw strings and numbers as they are', () {
    expect(redactBody('plain text'), 'plain text');
    expect(redactBody(42), 42);
    expect(redactBody(null), isNull);
  });

  test('masks hidden query values', () {
    expect(
      redactPathAndQuery(Uri.parse('https://x.io/api/a?token=t&page=2')),
      '/api/a?token=$hiddenValue&page=2',
    );
  });
}
