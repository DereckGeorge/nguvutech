import 'package:flutter/material.dart';

class ProfileSwitchItem extends StatelessWidget {
  final IconData icon;
  final String? iconAsset;
  final String title;
  final Color? textColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ProfileSwitchItem({
    Key? key,
    this.icon = Icons.circle,
    this.iconAsset,
    required this.title,
    this.textColor,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading:
          iconAsset != null
              ? Image.asset(
                iconAsset!,
                width: 24,
                height: 24,
                color: isDarkMode ? Colors.white : Colors.black,
              )
              : Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
