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

  @override
  String get dateFormatShort => 'd MMM، y';

  @override
  String get appearance => 'المظهر';

  @override
  String get behavior => 'السلوك';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get about => 'حول التطبيق';

  @override
  String get defaultIncrement => 'الزيادة الافتراضية';

  @override
  String defaultIncrementDescription(int increment) {
    return 'أزرار +/- السريعة تضيف $increment نقاط';
  }

  @override
  String get showNotesInList => 'إظهار الملاحظات في القائمة';

  @override
  String get showNotesInListDescription =>
      'عرض ملاحظات الإدخال بدلاً من النقاط فقط';

  @override
  String get dailyReminder => 'التذكير اليومي';

  @override
  String remindMeAt(String time) {
    return 'ذكرني في $time';
  }

  @override
  String get noReminderSet => 'لم يتم تعيين تذكير';

  @override
  String get appDescription =>
      'متتبع الأعمال الجيدة والسيئة اليومية\nالإصدار 1.0.0';

  @override
  String get type => 'النوع';

  @override
  String addAction(String type) {
    return 'إضافة عمل $type...';
  }

  @override
  String get editEntry => 'تعديل الإدخال';

  @override
  String get addEntryTitle => 'إضافة إدخال';

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get addNote2 => 'إضافة ملاحظة...';

  @override
  String get update => 'تحديث';

  @override
  String get deleteEntry => 'حذف الإدخال';

  @override
  String get entryDeleted => 'تم حذف الإدخال';

  @override
  String get undo => 'تراجع';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String net(String score) {
    return 'الصافي: $score';
  }

  @override
  String noEntriesYet(String type) {
    return 'لا توجد إدخالات $type بعد';
  }

  @override
  String get tapToAdd => 'اضغط + لإضافة إدخال سريع';

  @override
  String get addActionPlaceholder => 'أضف عمل...';

  @override
  String get defaultGoodAction => 'عمل جيد';

  @override
  String get defaultBadAction => 'عمل سيء';

  @override
  String get noGoodActionsToday => 'لا توجد أعمال جيدة اليوم';

  @override
  String get noBadActionsToday => 'لا توجد أعمال سيئة اليوم';
}
