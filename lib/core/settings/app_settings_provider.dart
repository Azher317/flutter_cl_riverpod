import 'package:app/core/storage/object_preference_provider.dart';
import 'package:app/core/storage/storage_keys.dart';
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
}

// keepAlive: App-lifetime service: settings.
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

  /// UI goes through `ref.changeThemeMode` / `ref.toggleThemeMode`
  /// (appearance_actions.dart) so every change plays the same reveal.
  Future<void> setThemeMode(ThemeMode mode) =>
      update((state) => state.copyWith(themeMode: mode));

  Future<void> setLocale(Locale? locale) =>
      update((state) => state.copyWith(localeCode: locale?.languageCode));
}
