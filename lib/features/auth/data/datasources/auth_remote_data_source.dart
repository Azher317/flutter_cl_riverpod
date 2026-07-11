import 'package:app/core/errors/exceptions.dart';
import 'package:app/features/auth/data/datasources/auth_client.dart';
import 'package:app/features/auth/data/models/login_request_model.dart';
import 'package:app/features/auth/data/models/user_model.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_data_source.g.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._authClient);

  final AuthClient _authClient;

  @override
  Future<UserModel> login(LoginParams params) async {
    try {
      final response = await _authClient.login(
        LoginRequestModel(phoneNumber: params.phone, password: params.password),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final data = e.response?.data;
        final msg = (data is Map) ? data['msg']?.toString() : null;
        throw InvalidCredentialsException(msg ?? 'Invalid credentials');
      }
      switch (e.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.transformTimeout:
          throw const NetworkException('Connection error');
        default:
          throw ServerException(e.message ?? 'Server error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(ref.watch(authClientProvider));
