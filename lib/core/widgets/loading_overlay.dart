import 'package:flutter/material.dart';

import '../utils/lottie_animations.dart';

/// A widget that shows a loading overlay with animation
class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({Key? key, this.message}) : super(key: key);

  /// Static method to show the loading overlay
  static Future<T> show<T>(
    BuildContext context, {
    required Future<T> future,
    String? message,
  }) async {
    // Show the loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingOverlay(message: message),
    );

    try {
      // Wait for the future to complete
      final result = await future;

      // Close the loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      return result;
    } catch (e) {
      // Close the loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Re-throw the error
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieAnimations.getLoadingAnimation(width: 100, height: 100),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
