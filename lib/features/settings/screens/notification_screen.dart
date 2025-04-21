import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management/core/theme/app_theme.dart';
import 'package:user_management/core/utils/responsive_layout.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
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
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;

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
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveContainer(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: settings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final title = settings.keys.elementAt(index);
            final value = settings[title]!;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  Switch(
                    value: value,
                    activeColor: Colors.white,
                    activeTrackColor: AppTheme.primaryColor,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade300,
                    onChanged: (newValue) {
                      setState(() {
                        settings[title] = newValue;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
