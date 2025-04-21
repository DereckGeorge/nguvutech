import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final Map<String, bool> settings = {
    "General Notification": true,
    "Sound": true,
    "Vibrate": false,
    "Special Offers": true,
    "Promo & Discount": false,
    "Payments": true,
    "Cashback": false,
    "App Updates": false,
    "New Service Available": true,
    "New Tips Available": false,
  };

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: settings.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final title = settings.keys.elementAt(index);
          final value = settings[title]!;
          return SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            value: value,
            activeColor: Colors.redAccent,
            onChanged: (newValue) {
              setState(() {
                settings[title] = newValue;
              });
            },
          );
        },
      ),
    );
  }
}
