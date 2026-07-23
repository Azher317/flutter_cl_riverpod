import 'package:app/core/errors/failures.dart';
import 'package:app/core/messaging/failure_messenger.dart';
import 'package:app/core/messaging/snackbar.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/validation/validation_regex.dart';
import 'package:app/core/widgets/buttons/filled_loading_button.dart';
import 'package:app/core/widgets/form_body.dart';
import 'package:app/core/widgets/form_fields/custom_text_form_field.dart';
import 'package:app/features/auth/presentation/notifiers/login_notifier.dart';
import 'package:app/features/auth/presentation/widgets/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends StatefulHookConsumerWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();

    final phoneFocus = useFocusNode();
    final passwordFocus = useFocusNode();

    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.isLoading;

    ref.listen<AsyncValue<void>>(loginProvider, (previous, next) {
      // On success, LoginNotifier hands the session to the core Session
      // notifier, and the router's redirect navigates to home — no imperative
      // navigation needed here.
      if (next is AsyncError) {
        final error = next.error;
        if (error is Failure) {
          context.showFailure(error);
        } else {
          AppMessenger.show(
            context.l10n.defaultErrorMessage,
            type: MessageType.error,
          );
        }
      }
    });

    void submit() {
      if (formKey.isNotValid()) return;
      ref
          .read(loginProvider.notifier)
          .login(
            phone: phoneController.text,
            password: passwordController.text,
          );
    }

    return Scaffold(
      body: FormBody(
        centered: true,
        spacing: Insets.medium,
        formKey: formKey,
        children: [
          CustomTextFormField(
            controller: phoneController,
            hintText: '7xxxxxxxxx',
            inputFormatters: [englishDigitsOnly],
            focusNode: phoneFocus,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(passwordFocus);
            },
            validator: context.validator.required().phone().build(),
          ),
          PasswordFormField(
            controller: passwordController,
            validator: context.validator.minLength(6).build(),
            focusNode: passwordFocus,
            onFieldSubmitted: (value) => submit(),
          ),
          const SizedBox(height: 56),
          FilledLoadingButton(
            onPressed: submit,
            isLoading: isLoading,
            child: Text(context.l10n.login),
          ),
        ],
      ),
    );
  }
}
