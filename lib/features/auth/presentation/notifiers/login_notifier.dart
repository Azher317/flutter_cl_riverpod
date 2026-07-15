import 'package:app/features/auth/di/auth_providers.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:app/features/auth/presentation/notifiers/auth_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> login({required String phone, required String password}) async {
    state = const AsyncLoading();

    final result = await ref
        .read(loginUseCaseProvider)
        .call(LoginParams(phone: phone, password: password));

    state = result.fold((failure) => AsyncError(failure, StackTrace.current), (
      session,
    ) {
      ref.read(authSessionProvider.notifier).setSession(session);
      return const AsyncData(null);
    });
  }
}
