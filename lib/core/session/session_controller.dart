abstract class SessionController {
  String? get token;
  bool get isSignedIn;
  Future<void> logout();
}
