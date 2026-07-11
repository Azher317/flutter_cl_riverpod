import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/l10n/generated/app_localizations.dart';
import 'package:app/core/l10n/locale.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter/widgets.dart'; // or material.dart

extension DeviceHeight on BuildContext {
  double get height => MediaQuery.of(this).size.height;
}

extension DeviceWidth on BuildContext {
  double get width => MediaQuery.of(this).size.width;
}

extension ValidatorX on BuildContext {
  ValidationBuilder get validator {
    final locale = AppFormValidatorLocale(this);
    return ValidationBuilder(
      optional: false,
      requiredMessage: locale.required(),
      locale: locale,
    );
  }
}

extension FormStateX on GlobalKey<FormState> {
  bool isNotValid() => !(currentState?.validate() ?? false);
}

extension NullableDateTimeExtension on DateTime? {
  String formatDate() {
    var inputFormat = DateFormat('MM/dd/yyyy');

    return this == null ? "" : inputFormat.format(this!);
  }
}

extension HttpResponseX<T> on Future<HttpResponse<T>> {
  Future<T> get data => then((value) => value.data);
}

extension ValueNotifierUpdated<T> on ValueNotifier<T> {
  void update(T newValue) => value = newValue;

  void updateNullable(T? newValue) {
    if (newValue != null) value = newValue;
  }
}

extension on ValidationBuilder {
  ValidationBuilder iraqiPhoneNumber(BuildContext context) {
    return add((v) {
      return RegExp(r"^(0|964|00964|\+964)?7[0-9]{9}$").hasMatch(v!)
          ? null
          : context.l10n.validatorPhoneNumber;
    });
  }
}

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  String get locale => l10n.localeName;
}

extension LocaleDirectionX on WidgetRef {
  TextDirection get direction {
    final code = watch(settingsProvider).localeCode;
    return code == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}

extension OppesitLocaleDirectionX on WidgetRef {
  TextDirection get oppesitDirection {
    final code = watch(settingsProvider).localeCode;
    return code == 'ar' ? TextDirection.ltr : TextDirection.rtl;
  }
}
