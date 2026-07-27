// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'App Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get crop => 'Crop';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get defaultErrorMessage => 'An error occurred, please try again later';

  @override
  String get badRequest => 'Invalid request, please check your input';

  @override
  String get conflict => 'This conflicts with existing data';

  @override
  String get forbidden => 'You don\'t have permission to perform this action';

  @override
  String get notFound => 'The requested item was not found';

  @override
  String get serverError => 'A server error occurred, please try again later';

  @override
  String get sessionExpired => 'Your session has expired, please sign in again';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidCredentials => 'Invalid phone number or password';

  @override
  String get invalidFieldValue => 'Invalid field value';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get locationPermissionIsRequiredToContinue =>
      'Location permission is required to continue';

  @override
  String get login => 'Login';

  @override
  String get loginSuccess => 'Logged in successfully';

  @override
  String get noConnection =>
      'No internet connection, please check your network';

  @override
  String get noItemsFoundError => 'No items found';

  @override
  String get notifications => 'Notifications';

  @override
  String get password => 'Password';

  @override
  String get phone => 'Phone';

  @override
  String get pickDate => 'Pick date';

  @override
  String get logout => 'Logout';

  @override
  String get relocate => 'Relocate';

  @override
  String get retry => 'Retry';

  @override
  String get search => 'Search';

  @override
  String get select => 'Select';

  @override
  String get switchTheme => 'Switch theme';

  @override
  String get theme => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get typeYourPasswordHere => 'Type your password here';

  @override
  String get typeYourUsenameHere => 'Type your username here';

  @override
  String get username => 'Username';

  @override
  String get validationEmail => 'Please enter a valid email';

  @override
  String get validationMaxLength => 'Please complete the required length';

  @override
  String get validationPhoneNumber => 'Please enter a valid phone number';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationUrl => 'Please enter a valid URL';

  @override
  String get validatorEmail => 'The field is not a valid email address';

  @override
  String validatorMaxLength(Object n) {
    return 'The field must be at most $n characters long';
  }

  @override
  String validatorMinLength(Object n) {
    return 'The field must be at least $n characters long';
  }

  @override
  String get validatorPhoneNumber => 'The field is not a valid phone number';

  @override
  String get validatorRequired => 'The field is required';

  @override
  String get validatorUrl => 'The field is not a valid URL address';

  @override
  String get validatorUseArabicOrKurdishLetters =>
      'Please use Arabic or Kurdish letters';

  @override
  String get validatorUseEnglishLetters => 'Please use English letters';

  @override
  String get welcomeAgain => 'Welcome again';

  @override
  String get previewTitle => 'Preview';

  @override
  String get previewTodayTitle => 'Today';

  @override
  String get previewTodaySubtitle => 'Cards, checkboxes and the tip banner.';

  @override
  String get previewWinterTip =>
      'During the winter your plants slow down and need less water.';

  @override
  String get previewLivingRoom => 'Living Room';

  @override
  String get previewKitchen => 'Kitchen';

  @override
  String get previewBalcony => 'Balcony';

  @override
  String get previewWater => 'Water';

  @override
  String get previewFeed => 'Feed';

  @override
  String get previewDetailTitle => 'Detail';

  @override
  String get previewDetailSubtitle =>
      'Hero typography, image block and info chips.';

  @override
  String get previewPlantName => 'Monstera Unique';

  @override
  String get previewPlantBody =>
      'A rare variegated monstera with deeply fenestrated leaves, each one splitting a little further as the plant matures. Give it bright indirect light — direct sun scorches the pale patches — and water only once the top inch of soil has dried out. It climbs by nature, so a moss pole keeps the newer leaves growing large instead of shrinking back. Wipe the leaves down monthly and feed every other watering through spring and summer.';

  @override
  String get previewMostPopular => 'Most Popular';

  @override
  String get previewMostPopularBody => 'This is a popular plant in store';

  @override
  String get previewEasyCare => 'Easy Care';

  @override
  String get previewEasyCareBody => 'Thrives on being forgotten';

  @override
  String get previewFaux => 'Faux Available';

  @override
  String get previewFauxBody => 'Get the look, zero upkeep';

  @override
  String get previewComponentsTitle => 'Components';

  @override
  String get previewComponentsSubtitle =>
      'Inputs, buttons and indicators as the theme renders them.';

  @override
  String get previewAssist => 'Assist';

  @override
  String get previewFilter => 'Filter';

  @override
  String get previewSuggestion => 'Suggestion';

  @override
  String get previewFilledButton => 'Filled button';

  @override
  String get previewOutlinedButton => 'Outlined button';

  @override
  String get previewTextButton => 'Text button';

  @override
  String get previewOverlaysTitle => 'Overlays';

  @override
  String get previewOverlaysSubtitle =>
      'Dialog, snackbars and the modal sheet. Tap to raise each one.';

  @override
  String get previewDialog => 'Dialog';

  @override
  String get previewBottomSheet => 'Bottom sheet';

  @override
  String get previewDialogTitle => 'Delete plant?';

  @override
  String get previewDialogBody => 'This placeholder dialog does nothing.';

  @override
  String get previewRooms => 'Rooms';

  @override
  String previewPlantCount(Object n) {
    return '$n plants';
  }

  @override
  String previewSnackMessage(Object type) {
    return 'A $type message.';
  }
}
