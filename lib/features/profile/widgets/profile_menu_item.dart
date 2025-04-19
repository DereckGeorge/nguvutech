import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String? iconAsset;
  final String title;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback onTap;

  const ProfileMenuItem({
    Key? key,
    this.icon = Icons.circle,
    this.iconAsset,
    required this.title,
    this.textColor,
    this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading:
          iconAsset != null
              ? Image.asset(
                iconAsset!,
                width: 24,
                height: 24,
                color: iconColor ?? (isDarkMode ? Colors.white : Colors.black),
              )
              : Icon(
                icon,
                color: iconColor ?? (isDarkMode ? Colors.white : Colors.black),
              ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
