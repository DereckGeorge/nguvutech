import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/responsive_layout.dart';

/// Custom bottom navigation bar that matches the design in the image
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DeviceScreenType.isDesktop(context) ? 32.0 : 8.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: 'assets/icons/Home.png',
                label: 'Home',
                index: 0,
                path: '/dashboard',
              ),
              _buildNavItem(
                context,
                icon: 'assets/icons/Notification.png',
                label: 'Activity',
                index: 1,
                path: '/activity',
              ),
              _buildNavItem(
                context,
                icon: 'assets/icons/Message.png',
                label: 'Chat',
                index: 2,
                path: '/chat',
              ),
              _buildNavItem(
                context,
                icon: 'assets/icons/Profile.png',
                label: 'Profile',
                index: 3,
                path: '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String icon,
    required String label,
    required int index,
    required String path,
  }) {
    final bool isSelected = index == currentIndex;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.grey[300]! : Colors.grey;

    return InkWell(
      onTap: () {
        if (!isSelected) {
          context.go(path);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceScreenType.isTablet(context) ? 24 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? primaryColor.withOpacity(isDarkMode ? 0.2 : 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              width: DeviceScreenType.isTablet(context) ? 28 : 24,
              height: DeviceScreenType.isTablet(context) ? 28 : 24,
              color: isSelected ? primaryColor : textColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: DeviceScreenType.isTablet(context) ? 14 : 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
