class RouteNames {
  const RouteNames._();

  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String logs = '/logs';

  /// Guest-mode apps only: screens a guest is sent to sign in for.
  static const Set<String> signedInOnly = {};
}
