import 'package:app/core/network/paginated.dart';

/// How this app's backend wraps its answers: the ONE file to rewrite for a
/// new backend.
///
/// At the start of a project, read the backend's API docs (Swagger or its
/// guide) and make these three functions match how it answers. Nothing else
/// in `core/` knows the backend's shape: [DioConsumer] unwraps every success
/// with [data], [NetworkErrorMapper] reads error text with [errorMessage],
/// and paged data sources parse pages with [page].
///
/// The defaults below fit a backend that answers
/// - success: `{"data": <payload>, "message": "..."}`, or the bare payload;
/// - error: `{"message": "..."}` or `{"error": {"message": "..."}}`;
/// - page: `{"items": [...], "totalCount": 42}`.
abstract final class ApiEnvelope {
  /// The payload of a successful response, with any wrapper removed.
  ///
  /// Default: a JSON object with a `data` key is unwrapped; anything else is
  /// already the payload. If your backend never wraps, return [body].
  static Object? data(Object? body) {
    if (body is Map && body.containsKey('data')) return body['data'];
    return body;
  }

  /// The short, user-facing message in an error body, or `null`.
  ///
  /// Only text inside a JSON object is ever read. A plain-text or HTML body
  /// is never returned: it is not meant for a user and may hold secrets.
  static String? errorMessage(Object? body) {
    if (body is! Map) return null;
    final error = body['error'];
    final raw = body['message'] ?? (error is Map ? error['message'] : null);
    if (raw is! String) return null;
    final message = raw.trim();
    if (message.isEmpty || message.length > maxMessageLength) return null;
    if (message.contains('<')) return null; // markup, not a sentence
    return message;
  }

  /// Longer than this, a "message" is a dump, not a sentence for a user.
  static const maxMessageLength = 200;

  /// One page of a list endpoint. [payload] is what [data] returned.
  static ApiPage<T> page<T>(
    Object? payload,
    T Function(Map<String, dynamic> json) item,
  ) {
    final json = payload! as Map<String, dynamic>;
    final items = (json['items'] as List<dynamic>? ?? const [])
        .map((e) => item(e as Map<String, dynamic>))
        .toList();
    return ApiPage(
      items,
      (json['totalCount'] as num?)?.toInt() ?? items.length,
    );
  }
}

/// A parsed page, ready for `PagingController.addItems`.
final class ApiPage<T> implements Paginated<T> {
  const ApiPage(this.result, this.total);

  @override
  final List<T> result;

  @override
  final int total;
}
