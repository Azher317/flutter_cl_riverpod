import 'package:app/core/network/callback.dart';
import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/network/endpoints.dart';
import 'package:app/features/auth/data/models/login_request_model.dart';
import 'package:app/features/auth/data/models/user_model.dart';

part 'auth_client.g.dart';

@riverpod
AuthClient authClient(Ref ref) => AuthClient(ref.dio);

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @Extra({'skipAuthLogout': true})
  @POST(Endpoints.login)
  FutureApiResponse<UserModel> login(@Body() LoginRequestModel data);
}
