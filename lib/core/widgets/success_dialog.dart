import 'package:flutter/material.dart';

import '../utils/lottie_animations.dart';

/// A dialog that shows a success animation with a message
class SuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onDismissed;

  const SuccessDialog({Key? key, required this.message, this.onDismissed})
    : super(key: key);

  /// Static method to show the dialog
  static Future<void> show(
    BuildContext context, {
    required String message,
    VoidCallback? onDismissed,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) =>
              SuccessDialog(message: message, onDismissed: onDismissed),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      if (onDismissed != null) {
        onDismissed!();
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieAnimations.getSuccessAnimation(width: 120, height: 120),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
