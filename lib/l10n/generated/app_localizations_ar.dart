// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'محاسبة - متتبع الأعمال اليومية';

  @override
  String get appTitleShort => 'محاسبة';

  @override
  String get good => 'جيد';

  @override
  String get bad => 'سيء';

  @override
  String get settings => 'الإعدادات';

  @override
  String get addEntry => 'إضافة إدخال';

  @override
  String get addNote => 'إضافة ملاحظة (اختياري)';

  @override
  String get score => 'النقاط';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get netScore => 'صافي النقاط';

  @override
  String get today => 'اليوم';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get deleteEntryConfirm => 'هل أنت متأكد من حذف هذا الإدخال؟';

  @override
  String get emptyState => 'لا توجد إدخالات لهذا اليوم. ابدأ في تتبع أعمالك!';

  @override
  String scoreValue(int score) {
    return '$score';
  }

  @override
  String get dateFormat => 'EEEE، d MMMM، y';
}
