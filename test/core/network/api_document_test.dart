import 'package:app/core/network/api_document.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // `flutter test` passes no env file, which is exactly the "forgot to name
  // a server" case.
  test('a build that names no server stops at launch', () {
    expect(ApiDocument.env, isEmpty);
    expect(ApiDocument.assertConfigured, throwsStateError);
  });

  group('check', () {
    test('accepts a real host with no trailing slash', () {
      expect(
        () => ApiDocument.check(env: 'uat', host: 'https://api.example.com'),
        returnsNormally,
      );
    });

    test('rejects a placeholder host', () {
      expect(
        () => ApiDocument.check(
          env: 'uat',
          host: 'https://UAT-HOST-NOT-SET.invalid',
        ),
        throwsStateError,
      );
    });

    test('rejects a host that ends with a slash, naming the problem', () {
      expect(
        () => ApiDocument.check(env: 'uat', host: 'https://api.example.com/'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            allOf(contains('ends with "/"'), contains('env/uat.json')),
          ),
        ),
      );
    });
  });
}
