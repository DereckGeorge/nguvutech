import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/system_ui_helper.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  static const String themePreferenceKey = 'theme_preference';
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadThemePreference();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Ensure system UI is correct when app is resumed
      _updateSystemUI();
    }
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

      // Update system UI based on the loaded theme
      _updateSystemUI();

      notifyListeners();
      debugPrint('Theme loaded: ${isDark ? "dark" : "light"}');
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _themeMode = ThemeMode.light;
      _isInitialized = true;
      notifyListeners();
    }
  }

  void _updateSystemUI() {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    SystemUIHelper.setOverlayStyleForBrightness(brightness);
  }

  Future<void> toggleTheme() async {
    try {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

      // Update system UI immediately after theme change
      _updateSystemUI();

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

      // Update system UI immediately after theme change
      _updateSystemUI();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(themePreferenceKey, isDark);

      debugPrint('Theme set to: ${isDark ? "dark" : "light"}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting theme: $e');
    }
  }
}
