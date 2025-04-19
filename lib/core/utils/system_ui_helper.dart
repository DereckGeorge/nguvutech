import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper class to set system UI overlay styles based on theme
class SystemUIHelper {
  /// Updates the system UI overlay style based on the current theme mode
  static void updateSystemUIOverlay(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode) {
      // For dark mode, use light icons (white color) on dark background
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // White status bar icons
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      // For light mode, use dark icons (black color) on light background
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Dark status bar icons
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }

  /// Sets the system UI overlay style for a specific brightness
  static void setOverlayStyleForBrightness(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      (isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light)
          .copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isLight ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: isLight ? Colors.white : Colors.black,
            systemNavigationBarIconBrightness:
                isLight ? Brightness.dark : Brightness.light,
          ),
    );
  }
}
