import 'package:app/core/network/api_document.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // `flutter test` passes no env file, which is exactly the "forgot to name
  // a server" case.
  test('a build that names no server stops at launch', () {
    expect(ApiDocument.env, isEmpty);
    expect(ApiDocument.assertConfigured, throwsStateError);
  });
}
