import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> get _localizedValues {
    if (locale.languageCode == 'ar') {
      return {
        'app_title': 'الاختيار العشوائي',
        'add_items': 'إضافة عناصر',
        'settings': 'الإعدادات',
        'wheel_of_fortune': 'عجلة الحظ',
        'dice': 'النرد',
        'coin': 'عملة',
        'random_choice': 'اختيار عشوائي',
        'result': 'النتيجة',
        'no_items': 'لا توجد عناصر',
        'add_items_first': 'الرجاء إضافة عناصر أولاً',
        'enter_text': 'أدخل نص العنصر...',
        'from_gallery': 'من المعرض',
        'from_camera': 'من الكاميرا',
        'upload_files': 'رفع ملفات متعددة',
        'delete_item': 'تم حذف العنصر',
        'undo': 'تراجع',
        'theme': 'المظهر',
        'auto': 'تلقائي',
        'light': 'فاتح',
        'dark': 'داكن',
        'primary_color': 'اللون الأساسي',
        'language': 'اللغة',
        'arabic': 'العربية',
        'english': 'English',
        'animations': 'الرسوم المتحركة',
        'enable_animations': 'تفعيل الرسوم المتحركة',
        'animations_subtitle': 'إضافة تأثيرات بصرية ممتعة',
        'version': 'الإصدار 1.0.0',
      };
    } else {
      return {
        'app_title': 'Random Choice',
        'add_items': 'Add Items',
        'settings': 'Settings',
        'wheel_of_fortune': 'Wheel of Fortune',
        'dice': 'Dice',
        'coin': 'Coin',
        'random_choice': 'Random Choice',
        'result': 'Result',
        'no_items': 'No items',
        'add_items_first': 'Please add items first',
        'enter_text': 'Enter item text...',
        'from_gallery': 'From Gallery',
        'from_camera': 'From Camera',
        'upload_files': 'Upload Multiple Files',
        'delete_item': 'Item deleted',
        'undo': 'Undo',
        'theme': 'Theme',
        'auto': 'Auto',
        'light': 'Light',
        'dark': 'Dark',
        'primary_color': 'Primary Color',
        'language': 'Language',
        'arabic': 'Arabic',
        'english': 'English',
        'animations': 'Animations',
        'enable_animations': 'Enable Animations',
        'animations_subtitle': 'Add fun visual effects',
        'version': 'Version 1.0.0',
      };
    }
  }

  String translate(String key) {
    return _localizedValues[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}