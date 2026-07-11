import 'package:app/core/errors/failures.dart';
import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/core/messaging/snackbar.dart';
import 'package:app/features/auth/presentation/notifiers/login_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.isLoading;

    ref.listen<AsyncValue<void>>(loginProvider, (previous, next) {
      // On success, LoginNotifier updates authSessionProvider, and the router's
      // redirect navigates to home — no imperative navigation needed here.
      if (next is AsyncError) {
        final error = next.error;
        final message = switch (error) {
          InvalidCredentialsFailure() => context.l10n.invalidCredentials,
          NetworkFailure() => context.l10n.noConnection,
          Failure() => error.message,
          _ => context.l10n.defaultErrorMessage,
        };
        Utils.showErrorSnackBar(message);
      }
    });

    void submit() {
      if (formKey.currentState?.validate() != true) return;
      ref
          .read(loginProvider.notifier)
          .login(
            phone: phoneController.text,
            password: passwordController.text,
          );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
