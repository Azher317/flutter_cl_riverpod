import 'package:app/core/errors/network_error_mapper.dart';
import 'package:app/core/network/dio_module.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_consumer.g.dart';

/// The app's HTTP surface. Data sources call these verbs and get back the
/// parsed JSON body (`response.data`); they never touch Dio. This replaces the
/// old Retrofit `@RestApi` clients.
///
/// `extra` is forwarded to the request (used for `{'skipAuthLogout': true}` on
/// the login call). The bearer token is attached automatically by the
/// `Authenticator` interceptor in `dio_module.dart`, so there is no
/// `requiresToken` flag here.
abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  });

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  });

  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  });

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  });

  // NOTE: multipart uploads (via `FormData`) go here when a real endpoint needs
  // them — one more case routed through `_send`. The existing
  // `MultipartFile`/`XFile` JsonConverters under `network/convertors/` still
  // apply since `MultipartFile` is a Dio type.
}

/// The single choke point where a raw transport error becomes an app exception:
/// [_send] is the only `on DioException` catch in the whole codebase.
class DioConsumer implements ApiConsumer {
  const DioConsumer(this._dio);

  final Dio _dio;

  Future<dynamic> _send(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, extra: extra),
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkErrorMapper.toException(e);
    }
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) => _send('GET', path, queryParameters: queryParameters, extra: extra);

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) => _send(
    'POST',
    path,
    data: data,
    queryParameters: queryParameters,
    extra: extra,
  );

  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) => _send(
    'PUT',
    path,
    data: data,
    queryParameters: queryParameters,
    extra: extra,
  );

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) => _send(
    'DELETE',
    path,
    data: data,
    queryParameters: queryParameters,
    extra: extra,
  );
}

@riverpod
ApiConsumer apiConsumer(Ref ref) => DioConsumer(ref.dio);
