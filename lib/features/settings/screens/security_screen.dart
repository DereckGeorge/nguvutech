import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management/core/theme/app_theme.dart';
import 'package:user_management/core/utils/responsive_layout.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _rememberMe = true;
  bool _faceId = true;
  bool _biometricId = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final buttonBgColor =
        isDarkMode ? Colors.grey[800] : const Color(0xFFFFF1F0);
    final buttonTextColor = const Color(0xFFF85F47);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Security',
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Remember me toggle
            _buildToggleOption('Remember me', _rememberMe, (value) {
              setState(() {
                _rememberMe = value;
              });
            }),

            const SizedBox(height: 16),

            // Face ID toggle
            _buildToggleOption('Face ID', _faceId, (value) {
              setState(() {
                _faceId = value;
              });
            }),

            const SizedBox(height: 16),

            // Biometric ID toggle
            _buildToggleOption('Biometric ID', _biometricId, (value) {
              setState(() {
                _biometricId = value;
              });
            }),

            const SizedBox(height: 16),

            // Google Authenticator option
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Google Authenticator',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: textColor.withOpacity(0.5),
              ),
              onTap: () {
                // TODO: Implement Google Authenticator navigation
              },
            ),

            const SizedBox(height: 32),

            // Change PIN button
            _buildActionButton(
              'Change PIN',
              buttonBgColor,
              buttonTextColor,
              () {
                // TODO: Implement Change PIN
              },
            ),

            const SizedBox(height: 16),

            // Change Password button
            _buildActionButton(
              'Change Password',
              buttonBgColor,
              buttonTextColor,
              () {
                // Navigate to change password screen
                context.push('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Row(
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
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    Color? backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
