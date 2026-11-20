import 'package:app/core/utils/extensions/string_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Reads API dates. A date-time with no time zone (`2026-11-19T10:00:00`) is
/// read as UTC, because servers send UTC; `DateTime.parse` alone would read
/// it as the phone's local time. Show it with `.toLocal()`.
class NullableDateTimeConvertor implements JsonConverter<DateTime?, String?> {
  const NullableDateTimeConvertor();

  static final _hasZone = RegExp(
    r'(Z|[+-]\d{2}:?\d{2})$',
    caseSensitive: false,
  );

  @override
  DateTime? fromJson(String? json) {
    if (json.isNullOrBlank) return null;
    final value = json!.trim();
    final utc = value.contains('T') && !_hasZone.hasMatch(value)
        ? '${value}Z'
        : value;
    return DateTime.tryParse(utc);
  }

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}
