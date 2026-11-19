import 'dart:io';

import 'package:app/core/errors/exceptions.dart';
import 'package:dio/dio.dart';

/// The single place raw transport errors are classified into the app's own
/// exception vocabulary. Pure and side-effect-free — no interceptors, no UI,
/// no logging. `DioConsumer` calls [toException] in its `on DioException`
/// catch so no data source ever repeats this switch.
///
/// Endpoint-specific meaning (e.g. login's 401 == wrong credentials) is NOT
/// handled here — that stays in the feature's data source, which catches the
/// generic app exception this produces and reinterprets it.
abstract class NetworkErrorMapper {
  const NetworkErrorMapper._();

  /// Generic transport classification, identical for every endpoint.
  static Exception toException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkException('Connection error');
      case DioExceptionType.badResponse:
        // Carry only the backend-provided message (or empty). Generic,
        // user-facing wording is the presentation layer's job and is localized
        // there (`FailureX.localizeFailure`) — the data layer never fabricates
        // English display strings. A 5xx never carries the server's text: it
        // can be a crash page with headers or tokens in it.
        final status = e.response?.statusCode ?? 0;
        final message = status >= 500 ? '' : messageFrom(e) ?? '';
        switch (status) {
          case 400:
            return BadRequestException(message);
          case 401:
            return UnauthorizedException(message);
          case 403:
            return ForbiddenException(message);
          case 404:
            return NotFoundException(message);
          case 409:
            return ConflictException(message);
          default:
            return ServerException(message);
        }
      case DioExceptionType.cancel:
        // Cancellation is deliberate (e.g. a superseded paginated request) and
        // should rarely surface to a user; classify it as a server-side
        // "didn't complete" if it ever does.
        return const ServerException('');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const NetworkException('No internet connection');
        }
        return const ServerException('');
    }
  }

  /// The backend's own error message, or `null` when it didn't send one.
  ///
  /// Only a short message inside a JSON object is ever read, in either of the
  /// two shapes backends use: `{"message": "..."}` or
  /// `{"error": {"message": "..."}}`. A plain-text or HTML body is never
  /// returned, because it is not meant for a user and may hold secrets.
  /// Every branch is null-safe by design — a throw inside error handling would
  /// itself be the bug.
  static String? messageFrom(DioException e) {
    final data = e.response?.data;
    if (data is! Map) return null;
    final error = data['error'];
    final raw = data['message'] ?? (error is Map ? error['message'] : null);
    if (raw is! String) return null;
    final message = raw.trim();
    if (message.isEmpty || message.length > maxMessageLength) return null;
    if (message.contains('<')) return null; // markup, not a sentence
    return message;
  }

  /// Longer than this, a "message" is a dump, not a sentence for a user.
  static const maxMessageLength = 200;
}
