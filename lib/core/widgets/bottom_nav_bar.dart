import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF15202B) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: 'assets/icons/Home.png',
                label: 'Home',
                index: 0,
                route: '/',
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                context: context,
                icon: 'assets/icons/Document.png',
                label: 'Orders',
                index: 1,
                route: '/orders',
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                context: context,
                icon: 'assets/icons/wishlist.png',
                label: 'Wishlist',
                index: 2,
                route: '/wishlist',
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                context: context,
                icon: 'assets/icons/Wallet.png',
                label: 'E-Wallet',
                index: 3,
                route: '/wallet',
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                context: context,
                icon: 'assets/icons/Profile.png',
                label: 'Profile',
                index: 4,
                route: '/profile',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String icon,
    required String label,
    required int index,
    required String route,
    required bool isDarkMode,
    bool isSelected = false,
  }) {
    final isActive = currentIndex == index;
    final accentColor = const Color(0xFFF85F47);
    final textColor =
        isActive
            ? accentColor
            : (isDarkMode ? Colors.grey[400] : Colors.grey[600]);

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          context.go(route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 24,
            height: 24,
            color:
                isActive
                    ? accentColor
                    : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
