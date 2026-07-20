import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/network/api_consumer.dart';
import 'package:app/core/network/endpoints.dart';
import 'package:app/features/auth/data/models/login_request_model.dart';
import 'package:app/features/auth/data/models/user_model.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_data_source.g.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api);

  final ApiConsumer _api;

  @override
  Future<UserModel> login(LoginParams params) async {
    try {
      final json = await _api.post(
        Endpoints.login,
        data: LoginRequestModel(
          phoneNumber: params.phone,
          password: params.password,
        ).toJson(),
        // A 401 here is "wrong credentials", not "session expired", so exempt
        // it from the global 401 -> logout interceptor.
        extra: const {'skipAuthLogout': true},
      );
      // The login endpoint returns the user (token nested inside) directly, not
      // wrapped in DefaultResponse — see the note in default_response.dart.
      return UserModel.fromJson(json as Map<String, dynamic>);
    } on UnauthorizedException catch (e) {
      // The one piece of error knowledge only this endpoint owns. Generic
      // transport -> exception mapping already happened in DioConsumer;
      // everything other than this 401 reinterpretation flows straight through.
      throw InvalidCredentialsException(e.message);
    }
  }
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(ref.watch(apiConsumerProvider));
