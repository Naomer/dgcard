import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'en.dart'; // Import your English translations
import 'ar.dart'; // Import your Arabic translations

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static Map<String, Map<String, String>> _localizedValues = {
    'en': en, // English map
    'ar': ar, // Arabic map
  };

  // Function to get the translation for a given key
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Method to get the delegate
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Delegate class for AppLocalizations
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Define getters for the various translations
  String get login => translate('login');
  String get noAccount => translate('noAccount');
  String get registerNow => translate('registerNow');
  String get language => translate('language');
  String get country => translate('country');
  String get allowNotifications => translate('allowNotifications');
  String get contactUs => translate('contactUs');
  String get ourStory => translate('ourStory');
  String get loyaltyPointsPolicy => translate('loyaltyPointsPolicy');
  String get privacyPolicy => translate('privacyPolicy');
  String get paymentMethod => translate('paymentMethod');
  String get footerText => translate('footerText');
  String get footerCopyright => translate('footerCopyright');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Check if the locale is supported
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Load AppLocalizations with the given locale
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
