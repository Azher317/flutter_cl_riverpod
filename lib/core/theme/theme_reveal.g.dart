// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_reveal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `true` while a circular reveal runs. The app then switches the theme with
/// no blend (`ThemeX.changeAnimation`), so the circle uncovers the final
/// colours, never a half-blended mix.
// keepAlive: App-lifetime: read by MaterialApp for the whole run.

@ProviderFor(ThemeRevealActive)
const themeRevealActiveProvider = ThemeRevealActiveProvider._();

/// `true` while a circular reveal runs. The app then switches the theme with
/// no blend (`ThemeX.changeAnimation`), so the circle uncovers the final
/// colours, never a half-blended mix.
// keepAlive: App-lifetime: read by MaterialApp for the whole run.
final class ThemeRevealActiveProvider
    extends $NotifierProvider<ThemeRevealActive, bool> {
  /// `true` while a circular reveal runs. The app then switches the theme with
  /// no blend (`ThemeX.changeAnimation`), so the circle uncovers the final
  /// colours, never a half-blended mix.
  // keepAlive: App-lifetime: read by MaterialApp for the whole run.
  const ThemeRevealActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeRevealActiveProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeRevealActiveHash();

  @$internal
  @override
  ThemeRevealActive create() => ThemeRevealActive();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$themeRevealActiveHash() => r'768569c18aa10dd67fa083a1cfd85238472147b7';

/// `true` while a circular reveal runs. The app then switches the theme with
/// no blend (`ThemeX.changeAnimation`), so the circle uncovers the final
/// colours, never a half-blended mix.
// keepAlive: App-lifetime: read by MaterialApp for the whole run.

abstract class _$ThemeRevealActive extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
