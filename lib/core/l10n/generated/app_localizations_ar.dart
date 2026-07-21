// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'اسم التطبيق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get crop => 'قص الصورة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get defaultErrorMessage => 'حدث خطأ ما, يرجى المحاولة مرة أخرى';

  @override
  String get badRequest => 'طلب غير صالح, يرجى التحقق من المدخلات';

  @override
  String get conflict => 'يتعارض هذا مع بيانات موجودة';

  @override
  String get forbidden => 'ليس لديك صلاحية لتنفيذ هذا الإجراء';

  @override
  String get notFound => 'العنصر المطلوب غير موجود';

  @override
  String get serverError => 'حدث خطأ في الخادم, يرجى المحاولة لاحقاً';

  @override
  String get sessionExpired =>
      'انتهت صلاحية الجلسة, يرجى تسجيل الدخول مرة أخرى';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidCredentials => 'رقم الهاتف أو كلمة المرور غير صحيحة';

  @override
  String get invalidFieldValue => 'قيمة حقل غير صالحة';

  @override
  String get lightMode => 'الوضع الصباحي';

  @override
  String get locationPermissionIsRequiredToContinue =>
      'يجب السماح بالوصول إلى الموقع للمتابعة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get noConnection => 'لا يوجد اتصال بالإنترنت, يرجى التحقق من الشبكة';

  @override
  String get noItemsFoundError => 'لا يوجد عناصر';

  @override
  String get password => 'كلمة المرور';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get pickDate => 'اختر التاريخ';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get relocate => 'إعادة تحديد الموقع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get search => 'بحث';

  @override
  String get select => 'اختر';

  @override
  String get switchTheme => 'تغيير اللون';

  @override
  String get theme => 'المظهر';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeSystem => 'النظام';

  @override
  String get typeYourPasswordHere => 'أدخل كلمة المرور هنا';

  @override
  String get typeYourUsenameHere => 'ادخل اسم المستخدم هنا';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get validationEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get validationMaxLength => 'الرجاء إكمال الطول المطلوب';

  @override
  String get validationPhoneNumber => 'الرجاء إدخال رقم هاتف صالح';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationUrl => 'الرجاء إدخال عنوان URL صالح';

  @override
  String get validatorEmail => 'البريد الإلكتروني غير صحيح';

  @override
  String validatorMaxLength(Object n) {
    return 'رجاءً أدخل $n أحرف على الأكثر';
  }

  @override
  String validatorMinLength(Object n) {
    return 'رجاءً أدخل $n أحرف على الأقل';
  }

  @override
  String get validatorPhoneNumber => 'رقم الهاتف غير صحيح';

  @override
  String get validatorRequired => 'هذا الحقل مطلوب';

  @override
  String get validatorUrl => 'الرابط غير صحيح';

  @override
  String get validatorUseArabicOrKurdishLetters =>
      'رجاءً أدخل حروف عربية أو كردية';

  @override
  String get validatorUseEnglishLetters => 'رجاءً أدخل حروف إنجليزية';

  @override
  String get welcomeAgain => 'مرحباً بك مرة أخرى';

  @override
  String get previewTitle => 'معاينة';

  @override
  String get previewTodayTitle => 'اليوم';

  @override
  String get previewTodaySubtitle => 'البطاقات ومربعات الاختيار وشريط التلميح.';

  @override
  String get previewWinterTip =>
      'في فصل الشتاء يتباطأ نمو نباتاتك وتحتاج إلى ماء أقل.';

  @override
  String get previewLivingRoom => 'غرفة المعيشة';

  @override
  String get previewKitchen => 'المطبخ';

  @override
  String get previewBalcony => 'الشرفة';

  @override
  String get previewWater => 'سقاية';

  @override
  String get previewFeed => 'تسميد';

  @override
  String get previewDetailTitle => 'التفاصيل';

  @override
  String get previewDetailSubtitle =>
      'خطوط العناوين وصورة العرض وبطاقات المعلومات.';

  @override
  String get previewPlantName => 'مونستيرا يونيك';

  @override
  String get previewPlantBody =>
      'مونستيرا مبرقشة نادرة بأوراق عميقة التشقق, يزداد انشقاقها كلما نضج النبات. ضعها في ضوء ساطع غير مباشر — فأشعة الشمس المباشرة تحرق المساحات الفاتحة — واسقها فقط عند جفاف الطبقة العليا من التربة. وهي نبتة متسلقة بطبعها, لذا يساعد عمود الطحلب على إبقاء الأوراق الجديدة كبيرة بدل أن تصغر. امسح الأوراق شهرياً وسمّدها كل ريّتين خلال الربيع والصيف.';

  @override
  String get previewMostPopular => 'الأكثر رواجاً';

  @override
  String get previewMostPopularBody => 'هذا النبات من الأكثر مبيعاً في المتجر';

  @override
  String get previewEasyCare => 'سهل العناية';

  @override
  String get previewEasyCareBody => 'ينمو جيداً حتى مع الإهمال';

  @override
  String get previewFaux => 'يتوفر صناعي';

  @override
  String get previewFauxBody => 'المظهر نفسه دون أي عناية';

  @override
  String get previewComponentsTitle => 'العناصر';

  @override
  String get previewComponentsSubtitle =>
      'حقول الإدخال والأزرار والمؤشرات كما يعرضها الثيم.';

  @override
  String get previewAssist => 'مساعدة';

  @override
  String get previewFilter => 'تصفية';

  @override
  String get previewSuggestion => 'اقتراح';

  @override
  String get previewFilledButton => 'زر ممتلئ';

  @override
  String get previewOutlinedButton => 'زر محدد';

  @override
  String get previewTextButton => 'زر نصي';

  @override
  String get previewOverlaysTitle => 'النوافذ المنبثقة';

  @override
  String get previewOverlaysSubtitle =>
      'الحوار والتنبيهات والنافذة السفلية. اضغط لإظهار كل منها.';

  @override
  String get previewDialog => 'حوار';

  @override
  String get previewBottomSheet => 'نافذة سفلية';

  @override
  String get previewDialogTitle => 'حذف النبات؟';

  @override
  String get previewDialogBody => 'هذا الحوار للعرض فقط ولا يقوم بأي إجراء.';

  @override
  String get previewRooms => 'الغرف';

  @override
  String previewPlantCount(Object n) {
    return '$n نباتات';
  }

  @override
  String previewSnackMessage(Object type) {
    return 'رسالة $type.';
  }
}
