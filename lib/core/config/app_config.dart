/// Per-app choices made once, when a new app is started from this
/// structure (`bin/new_app.sh` asks and writes them here).
abstract final class AppConfig {
  /// How phone numbers are typed, shown, checked and sent.
  /// See [PhoneFormat].
  static const PhoneFormat phoneFormat = PhoneFormat.iraqi;

  /// Whether people must sign in before using the app. See [SignInMode].
  static const SignInMode signIn = SignInMode.required;
}

enum SignInMode {
  /// Nothing is usable signed out: every screen sits behind the sign-in.
  required,

  /// People browse as guests and sign in only when an action needs an
  /// account (`ref.requireSignIn(context, then)`); screens that need one are
  /// listed in `RouteNames.signedInOnly`.
  guest,

  /// The app has no sign-in.
  none,
}

enum PhoneFormat {
  /// Iraqi mobiles only: typed and shown as `07XX XXX XXXX`, sent as
  /// `07XXXXXXXXX` (IraqiPhone). No country picker.
  iraqi,

  /// Any country: a country-code picker (Iraq preselected) plus the local
  /// number, sent as `+<code><number>`.
  international,
}
