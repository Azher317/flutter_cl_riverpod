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
        // English display strings.
        final message = messageFrom(e) ?? '';
        switch (e.response?.statusCode) {
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
        return ServerException(messageFrom(e) ?? '');
    }
  }

  /// The backend's own error message, or `null` when it didn't send one.
  /// Every branch is null-safe by design — a throw inside error handling would
  /// itself be the bug.
  static String? messageFrom(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
    }
    if (data is String && data.isNotEmpty) return data;
    return null;
  }
}
