// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pushMessaging)
const pushMessagingProvider = PushMessagingProvider._();

final class PushMessagingProvider
    extends $FunctionalProvider<PushMessaging, PushMessaging, PushMessaging>
    with $Provider<PushMessaging> {
  const PushMessagingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushMessagingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushMessagingHash();

  @$internal
  @override
  $ProviderElement<PushMessaging> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushMessaging create(Ref ref) {
    return pushMessaging(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushMessaging value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushMessaging>(value),
    );
  }
}

String _$pushMessagingHash() => r'6b23dc75eefdd211f71c20728c5c0bfe12077fdb';

@ProviderFor(pushTokenRegistrar)
const pushTokenRegistrarProvider = PushTokenRegistrarProvider._();

final class PushTokenRegistrarProvider
    extends
        $FunctionalProvider<
          PushTokenRegistrar,
          PushTokenRegistrar,
          PushTokenRegistrar
        >
    with $Provider<PushTokenRegistrar> {
  const PushTokenRegistrarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTokenRegistrarProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTokenRegistrarHash();

  @$internal
  @override
  $ProviderElement<PushTokenRegistrar> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushTokenRegistrar create(Ref ref) {
    return pushTokenRegistrar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushTokenRegistrar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushTokenRegistrar>(value),
    );
  }
}

String _$pushTokenRegistrarHash() =>
    r'9bc0e80ae032aa125fb59420abc5b43f8e54a5e8';

/// Where a tapped notification wants to go, until the router can take it
/// (it waits while the splash is up). `PushHost` opens it and clears it.
// keepAlive: App-lifetime service: push.

@ProviderFor(PendingPushRoute)
const pendingPushRouteProvider = PendingPushRouteProvider._();

/// Where a tapped notification wants to go, until the router can take it
/// (it waits while the splash is up). `PushHost` opens it and clears it.
// keepAlive: App-lifetime service: push.
final class PendingPushRouteProvider
    extends $NotifierProvider<PendingPushRoute, String?> {
  /// Where a tapped notification wants to go, until the router can take it
  /// (it waits while the splash is up). `PushHost` opens it and clears it.
  // keepAlive: App-lifetime service: push.
  const PendingPushRouteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingPushRouteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingPushRouteHash();

  @$internal
  @override
  PendingPushRoute create() => PendingPushRoute();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingPushRouteHash() => r'6246bc8c11832d7063fc58c641595bd3789f5e9d';

/// Where a tapped notification wants to go, until the router can take it
/// (it waits while the splash is up). `PushHost` opens it and clears it.
// keepAlive: App-lifetime service: push.

abstract class _$PendingPushRoute extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// The push plumbing every app needs, whatever the provider:
///
/// - the device token goes to the backend while signed in (launch, sign-in,
///   token refresh) and is withdrawn right after sign-out;
/// - a tap (app open, in the background, or launched from closed) queues its
///   [PushMessage.route] for `PushHost`, which opens it once the splash is
///   gone.
///
/// Started by `PushHost`. With the default [NoPushMessaging] it does
/// nothing.
// keepAlive: App-lifetime service: push.

@ProviderFor(PushController)
const pushControllerProvider = PushControllerProvider._();

/// The push plumbing every app needs, whatever the provider:
///
/// - the device token goes to the backend while signed in (launch, sign-in,
///   token refresh) and is withdrawn right after sign-out;
/// - a tap (app open, in the background, or launched from closed) queues its
///   [PushMessage.route] for `PushHost`, which opens it once the splash is
///   gone.
///
/// Started by `PushHost`. With the default [NoPushMessaging] it does
/// nothing.
// keepAlive: App-lifetime service: push.
final class PushControllerProvider
    extends $NotifierProvider<PushController, void> {
  /// The push plumbing every app needs, whatever the provider:
  ///
  /// - the device token goes to the backend while signed in (launch, sign-in,
  ///   token refresh) and is withdrawn right after sign-out;
  /// - a tap (app open, in the background, or launched from closed) queues its
  ///   [PushMessage.route] for `PushHost`, which opens it once the splash is
  ///   gone.
  ///
  /// Started by `PushHost`. With the default [NoPushMessaging] it does
  /// nothing.
  // keepAlive: App-lifetime service: push.
  const PushControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushControllerHash();

  @$internal
  @override
  PushController create() => PushController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushControllerHash() => r'8ae5c731910864ba07e3055bd8547ea9af83e10d';

/// The push plumbing every app needs, whatever the provider:
///
/// - the device token goes to the backend while signed in (launch, sign-in,
///   token refresh) and is withdrawn right after sign-out;
/// - a tap (app open, in the background, or launched from closed) queues its
///   [PushMessage.route] for `PushHost`, which opens it once the splash is
///   gone.
///
/// Started by `PushHost`. With the default [NoPushMessaging] it does
/// nothing.
// keepAlive: App-lifetime service: push.

abstract class _$PushController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
