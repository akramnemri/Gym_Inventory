// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _prefKey = 'locale';
  Locale? _locale;
  Locale? get locale => _locale;

  LocaleProvider([this._locale]);

  /// Set a locale and persist it
  Future<void> setLocale(Locale locale) async {
    if (_locale != null && _locale!.languageCode == locale.languageCode) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }

  /// Clear saved locale (falls back to system locale)
  Future<void> clearLocale() async {
    _locale = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }

  /// helper to get saved locale in main() before creating provider
  static Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code == null) return null;
    return Locale(code);
  }
}
