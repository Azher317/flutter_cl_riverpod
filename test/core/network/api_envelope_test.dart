import 'package:app/core/network/api_envelope.dart';
import 'package:app/core/network/convertors/nullable_date_time_convertor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiEnvelope.data', () {
    test('unwraps {data}', () {
      expect(ApiEnvelope.data({'data': 1, 'message': ''}), 1);
    });
    test('a bare payload passes through', () {
      expect(ApiEnvelope.data([1, 2]), [1, 2]);
      expect(ApiEnvelope.data({'id': 3}), {'id': 3});
    });
  });

  test('ApiEnvelope.page reads items and the total', () {
    final page = ApiEnvelope.page<int>({
      'items': [
        {'id': 1},
        {'id': 2},
      ],
      'totalCount': 9,
    }, (j) => j['id'] as int);
    expect(page.result, [1, 2]);
    expect(page.total, 9);
  });

  group('NullableDateTimeConvertor', () {
    const c = NullableDateTimeConvertor();
    test('a date-time without a zone is read as UTC', () {
      final d = c.fromJson('2026-11-19T10:00:00')!;
      expect(d.isUtc, isTrue);
      expect(d.hour, 10);
    });
    test('an explicit zone is kept', () {
      expect(c.fromJson('2026-11-19T10:00:00+03:00')!.toUtc().hour, 7);
      expect(c.fromJson('2026-11-19T10:00:00Z')!.isUtc, isTrue);
    });
    test('blank or broken input is null, never a crash', () {
      expect(c.fromJson(null), isNull);
      expect(c.fromJson(' '), isNull);
      expect(c.fromJson('not a date'), isNull);
    });
  });
}
