import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesRepository {
  AppPreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  static const String _onboardingKey = 'hasSeenOnboarding';
  static const String _tourKey = 'hasSeenAppTour';
  static const String _themeKey = 'themeMode';
  static const String _localeKey = 'localeCode';

  static Future<AppPreferencesRepository> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return AppPreferencesRepository(prefs);
  }

  bool hasSeenOnboarding() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_onboardingKey, value);
  }

  bool hasSeenAppTour() {
    return _prefs.getBool(_tourKey) ?? false;
  }

  Future<void> setHasSeenAppTour(bool value) async {
    await _prefs.setBool(_tourKey, value);
  }

  ThemeMode getThemeMode() {
    final String? stored = _prefs.getString(_themeKey);
    switch (stored) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final String value;
    switch (mode) {
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
      case ThemeMode.light:
      default:
        value = 'light';
        break;
    }
    await _prefs.setString(_themeKey, value);
  }

  Locale getLocale() {
    final String? code = _prefs.getString(_localeKey);
    if (code == null || code.isEmpty) {
      return const Locale('en');
    }
    return Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }
}
