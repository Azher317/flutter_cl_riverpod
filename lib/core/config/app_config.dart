/// Per-app choices made once, when a new app is started from this
/// structure (`bin/rename.sh` asks and writes them here).
abstract final class AppConfig {
  /// How phone numbers are typed, shown, checked and sent.
  /// See [PhoneFormat].
  static const PhoneFormat phoneFormat = PhoneFormat.iraqi;
}

enum PhoneFormat {
  /// Iraqi mobiles only: typed and shown as `07XX XXX XXXX`, sent as
  /// `07XXXXXXXXX` (IraqiPhone). No country picker.
  iraqi,

  /// Any country: a country-code picker (Iraq preselected) plus the local
  /// number, sent as `+<code><number>`.
  international,
}
