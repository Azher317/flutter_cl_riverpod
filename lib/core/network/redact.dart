import 'package:dio/dio.dart';

/// What a masked value prints as.
const String hiddenValue = '*****';

/// Body and query keys whose values never print, compared without case.
/// Add any new personal field (national id, address) here.
const Set<String> hiddenBodyKeys = {
  'password',
  'token',
  'accessToken',
  'access_token',
  'refreshToken',
  'refresh_token',
  'otp',
  'pin',
  'secret',
  'newPassword',
  'oldPassword',
  'confirmPassword',
  'phone',
  'phoneNumber',
  'phoneCountryCode',
  'email',
};

final Set<String> _hiddenLower = {
  for (final key in hiddenBodyKeys) key.toLowerCase(),
};

bool _isHidden(Object? key) =>
    _hiddenLower.contains(key.toString().toLowerCase());

/// A copy of [data] with the value of every key in [hiddenBodyKeys] masked,
/// walking nested maps and lists. The source is never changed.
///
/// [FormData] becomes a map of its fields plus file names. An object with a
/// `toJson()` (a request model) is converted first, so it can't skip the
/// masking. Anything else (a raw string, bytes, a stream) is returned as is.
///
/// Not a security boundary: it only masks the keys it knows.
Object? redactBody(Object? data) {
  if (data is Map) {
    return {
      for (final entry in data.entries)
        entry.key.toString(): _isHidden(entry.key)
            ? hiddenValue
            : redactBody(entry.value),
    };
  }
  if (data is List) return data.map(redactBody).toList();
  if (data is FormData) {
    return {
      for (final field in data.fields)
        field.key: _isHidden(field.key) ? hiddenValue : field.value,
      for (final file in data.files)
        file.key: '<file ${file.value.filename ?? ''}>',
    };
  }
  if (data == null || data is String || data is num || data is bool) {
    return data;
  }
  final json = _tryToJson(data);
  return json == null ? data : redactBody(json);
}

/// [uri] as `path?query`, with hidden query values masked.
String redactPathAndQuery(Uri uri) {
  if (uri.queryParameters.isEmpty) return uri.path;
  final query = uri.queryParameters.entries
      .map((e) => '${e.key}=${_isHidden(e.key) ? hiddenValue : e.value}')
      .join('&');
  return '${uri.path}?$query';
}

Object? _tryToJson(Object data) {
  try {
    // ignore: avoid_dynamic_calls
    return (data as dynamic).toJson() as Object?;
  } on NoSuchMethodError {
    return null;
  }
}
