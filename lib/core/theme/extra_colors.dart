import 'package:app/core/theme/colors/color_schemes.dart';
import 'package:flutter/material.dart';

class AppStatusColors extends ThemeExtension<AppStatusColors> {
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;

  const AppStatusColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
  });

  /// Dedicated, brightness-aware status palette generated from fixed green /
  /// amber / blue seeds so `success`/`warning`/`info` stay recognizable
  /// regardless of the app's brand seed. The seeds themselves live in
  /// `AppColors`; the schemes in [AppColorSchemes].
  factory AppStatusColors.of(Brightness b) {
    final ok = AppColorSchemes.success(b);
    final warn = AppColorSchemes.warning(b);
    final info = AppColorSchemes.info(b);
    return AppStatusColors(
      success: ok.primary,
      onSuccess: ok.onPrimary,
      warning: warn.primary,
      onWarning: warn.onPrimary,
      info: info.primary,
      onInfo: info.onPrimary,
    );
  }

  @override
  ThemeExtension<AppStatusColors> copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
    );
  }

  @override
  ThemeExtension<AppStatusColors> lerp(
    covariant ThemeExtension<AppStatusColors>? other,
    double t,
  ) {
    if (other is! AppStatusColors) return this;

    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,

      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,

      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
    );
  }
}

extension AppStatusColorsX on ThemeData {
  AppStatusColors get appStatusColors =>
      extension<AppStatusColors>() ?? AppStatusColors.of(brightness);
}
