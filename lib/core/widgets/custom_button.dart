import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height = 56,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonStyle =
        isOutlined
            ? OutlinedButton.styleFrom(
              foregroundColor: textColor ?? theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
              minimumSize: Size(width ?? double.infinity, height),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            )
            : ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? theme.colorScheme.primary,
              foregroundColor: textColor ?? Colors.white,
              minimumSize: Size(width ?? double.infinity, height),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            );

    final buttonChild =
        isLoading
            ? Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOutlined
                        ? theme.colorScheme.primary
                        : textColor ?? Colors.white,
                  ),
                ),
              ),
            )
            : Row(
              mainAxisAlignment:
                  icon != null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            );

    return isOutlined
        ? OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        ).animate().fadeIn().scale(delay: 200.ms, duration: 300.ms)
        : ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        ).animate().fadeIn().scale(delay: 200.ms, duration: 300.ms);
  }
}
