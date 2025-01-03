import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  bool _isArabic = false;

  bool get isArabic => _isArabic;

  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners(); // Notify the app that the language has changed
  }

  // Set language directly
  void setLanguage(bool isArabic) {
    _isArabic = isArabic;
    notifyListeners(); // Notify listeners of the change
  }

  Locale get locale => _isArabic ? Locale('ar') : Locale('en');

  TextDirection get textDirection =>
      _isArabic ? TextDirection.rtl : TextDirection.ltr;
}
