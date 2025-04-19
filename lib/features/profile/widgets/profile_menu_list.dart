import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/auth_provider.dart';
import '../../../core/theme/theme_provider.dart';
import 'profile_menu_item.dart';
import 'profile_switch_item.dart';

class ProfileMenuList extends StatelessWidget {
  final VoidCallback onEditProfileTap;

  const ProfileMenuList({Key? key, required this.onEditProfileTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Column(
      children: [
        ProfileMenuItem(
          iconAsset: 'assets/icons/Calendar.png',
          title: 'My Favorite Restaurants',
          textColor: textColor,
          onTap: () {},
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/Discount.png',
          title: 'Special Offers & Promo',
          textColor: textColor,
          onTap: () {},
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/Wallet.png',
          title: 'Payment Methods',
          textColor: textColor,
          onTap: () {},
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/Profile.png',
          title: 'Profile',
          textColor: textColor,
          onTap: onEditProfileTap,
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/Location.png',
          title: 'Address',
          textColor: textColor,
          onTap: () {},
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/Notification.png',
          title: 'Notification',
          textColor: textColor,
          onTap: () {},
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/Shield Done.png',
          title: 'Security',
          textColor: textColor,
          onTap: () {},
        ),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return ProfileSwitchItem(
              iconAsset: 'assets/icons/Show.png',
              title: 'Dark Mode',
              textColor: textColor,
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            );
          },
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/Info Square.png',
          title: 'Help Center',
          textColor: textColor,
          onTap: () {},
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/3User.png',
          title: 'Invite Friends',
          textColor: textColor,
          onTap: () {},
        ),
        ProfileMenuItem(
          iconAsset: 'assets/icons/Logout.png',
          title: 'Logout',
          textColor: const Color(0xFFF85F47),
          iconColor: const Color(0xFFF85F47),
          onTap: () async {
            await Provider.of<AuthProvider>(context, listen: false).signOut();
            if (context.mounted) {
              context.go('/sign-in');
            }
          },
        ),
      ],
    );
  }
}
