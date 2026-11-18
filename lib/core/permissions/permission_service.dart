import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service.g.dart';

/// Runtime permissions an app may ask for. Add one only when an app needs it
/// (and ask the app owner first: forced or optional — docs/permissions.md).
enum AppPermission {
  camera,
  photos,
  microphone,

  /// Location while the app is in use.
  locationWhenInUse,

  /// Background location. Only requestable once [locationWhenInUse] is
  /// granted.
  locationAlways,
  notifications,
}

/// The OS answer, collapsed to what the UI branches on.
enum AppPermissionStatus {
  granted,

  /// Denied, but the OS will still show its prompt next time.
  denied,

  /// The OS won't prompt again; only the Settings app can change it.
  permanentlyDenied,
}

/// The app's only doorway to the permission plugin. Screens never call it
/// directly: they use `ensurePermission` (permission_flow.dart), which wraps
/// the prompt in the explain / settings flow.
///
/// OPT-IN: the structure ships no plugin. An app that needs permissions adds
/// `permission_handler`, writes the adapter from docs/permissions.md and
/// overrides [permissionServiceProvider] in `main.dart`.
abstract interface class PermissionService {
  Future<AppPermissionStatus> status(AppPermission permission);

  /// Shows the OS prompt when it still can; otherwise returns the current
  /// status unchanged.
  Future<AppPermissionStatus> request(AppPermission permission);

  /// Opens this app's page in the system Settings. `false` if it couldn't.
  Future<bool> openSettings();
}

/// The default until an app sets permissions up: using it is a programming
/// error, so it fails loudly instead of silently reporting "denied".
class UnconfiguredPermissionService implements PermissionService {
  const UnconfiguredPermissionService();

  static Never _fail() => throw StateError(
    'Permissions are not set up in this app. Follow docs/permissions.md '
    '(add permission_handler, the adapter, and override '
    'permissionServiceProvider in main.dart).',
  );

  @override
  Future<AppPermissionStatus> status(AppPermission permission) => _fail();

  @override
  Future<AppPermissionStatus> request(AppPermission permission) => _fail();

  @override
  Future<bool> openSettings() => _fail();
}

// keepAlive: App-lifetime service: permissions.
@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) =>
    const UnconfiguredPermissionService();
