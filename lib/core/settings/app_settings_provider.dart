// ignore_for_file: avoid_build_context_in_providers
import 'package:app/core/storage/object_preference_provider.dart';
import 'package:app/core/storage/storage_keys.dart';
import 'package:app/core/theme/theme_change.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_settings_provider.freezed.dart';
part 'app_settings_provider.g.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const AppSettings._();

  const factory AppSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(null) String? localeCode,
  }) = _AppSettings;

  Locale? get locale => localeCode == null ? null : Locale(localeCode!);

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  void setLocale(String s) {}
}

@Riverpod(keepAlive: true)
class Settings extends _$Settings with ObjectPreferenceProvider<AppSettings> {
  @override
  @protected
  String get key => PreferenceKeys.settings;

  @override
  AppSettings fromJson(Map<String, dynamic> map) => AppSettings.fromJson(map);

  @override
  Map<String, dynamic> toJson(AppSettings value) => value.toJson();

  @override
  AppSettings build() => firstBuild(const AppSettings());

  Future<void> toggleThemeMode(BuildContext context) => update(
    (state) => state.copyWith(
      themeMode: ThemeX.getOppositeThemeMode(state.themeMode, context),
    ),
  );

  Future<void> setLocale(Locale? locale) =>
      update((state) => state.copyWith(localeCode: locale?.languageCode));

  Future<void> toggleLocale() => update(
    (state) => state.copyWith(
      localeCode: state.locale?.languageCode == 'en' ? 'ar' : 'en',
    ),
  );
}
