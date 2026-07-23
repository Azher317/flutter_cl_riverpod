import 'dart:io';

import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/errors/network_error_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final options = RequestOptions(path: '/x');

  DioException badResponse(int status, {Object? data}) => DioException(
    requestOptions: options,
    response: Response(
      requestOptions: options,
      statusCode: status,
      data: data,
    ),
    type: DioExceptionType.badResponse,
  );

  group('NetworkErrorMapper.toException', () {
    test('all timeout/connection types -> NetworkException', () {
      const timeoutTypes = [
        DioExceptionType.connectionError,
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.transformTimeout,
      ];
      for (final type in timeoutTypes) {
        expect(
          NetworkErrorMapper.toException(
            DioException(requestOptions: options, type: type),
          ),
          isA<NetworkException>(),
          reason: '$type should map to NetworkException',
        );
      }
    });

    test('status codes map to their exception types', () {
      expect(
        NetworkErrorMapper.toException(badResponse(400)),
        isA<BadRequestException>(),
      );
      expect(
        NetworkErrorMapper.toException(badResponse(401)),
        isA<UnauthorizedException>(),
      );
      expect(
        NetworkErrorMapper.toException(badResponse(403)),
        isA<ForbiddenException>(),
      );
      expect(
        NetworkErrorMapper.toException(badResponse(404)),
        isA<NotFoundException>(),
      );
      expect(
        NetworkErrorMapper.toException(badResponse(409)),
        isA<ConflictException>(),
      );
      expect(
        NetworkErrorMapper.toException(badResponse(500)),
        isA<ServerException>(),
      );
      // Any unmapped status falls through to ServerException.
      expect(
        NetworkErrorMapper.toException(badResponse(418)),
        isA<ServerException>(),
      );
    });

    test('carries the backend message when present', () {
      final e = NetworkErrorMapper.toException(
        badResponse(400, data: {'message': 'Phone already used'}),
      );
      expect((e as BadRequestException).message, 'Phone already used');
    });

    test('no backend message -> empty (presenter localizes by type)', () {
      final e = NetworkErrorMapper.toException(badResponse(400));
      expect((e as BadRequestException).message, isEmpty);
    });

    test('unknown + SocketException -> NetworkException', () {
      final e = NetworkErrorMapper.toException(
        DioException(
          requestOptions: options,
          // type defaults to DioExceptionType.unknown
          error: const SocketException('offline'),
        ),
      );
      expect(e, isA<NetworkException>());
    });

    test('cancel -> ServerException', () {
      final e = NetworkErrorMapper.toException(
        DioException(requestOptions: options, type: DioExceptionType.cancel),
      );
      expect(e, isA<ServerException>());
    });
  });

  group('NetworkErrorMapper.messageFrom', () {
    test('reads {message} from a map body', () {
      expect(
        NetworkErrorMapper.messageFrom(
          badResponse(400, data: {'message': 'bad'}),
        ),
        'bad',
      );
    });

    test('reads a plain string body', () {
      expect(
        NetworkErrorMapper.messageFrom(badResponse(400, data: 'oops')),
        'oops',
      );
    });

    test('null when the backend sent no message', () {
      expect(NetworkErrorMapper.messageFrom(badResponse(400)), isNull);
    });
  });
}
