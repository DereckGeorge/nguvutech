import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String themePreferenceKey = 'theme_preference';
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isInitialized => _isInitialized;

  Future<void> _loadThemePreference() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isDark = prefs.getBool(themePreferenceKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      _isInitialized = true;
      notifyListeners();
      debugPrint('Theme loaded: ${isDark ? "dark" : "light"}');
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _themeMode = ThemeMode.light;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    try {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(themePreferenceKey, _themeMode == ThemeMode.dark);

      debugPrint(
        'Theme toggled to: ${_themeMode == ThemeMode.dark ? "dark" : "light"}',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling theme: $e');
    }
  }

  Future<void> setDarkMode(bool isDark) async {
    try {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(themePreferenceKey, isDark);

      debugPrint('Theme set to: ${isDark ? "dark" : "light"}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting theme: $e');
    }
  }
}
