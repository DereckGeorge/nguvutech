import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/auth_provider.dart';
import '../../../core/utils/lottie_animations.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/success_dialog.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../settings/screens/settings_screen.dart';
import '../../../core/theme/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();

    // Set status bar to light (dark icons) for light theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Show a bottom sheet with options
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

      // User canceled the selection
      if (source == null) return;

      // Pick the image
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _isLoading = true;
        });

        // Upload the image
        final success = await Provider.of<AuthProvider>(
          context,
          listen: false,
        ).updateAvatar(image.path);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (success) {
            // Show success dialog with animation
            SuccessDialog.show(
              context,
              message: 'Profile picture updated successfully',
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update profile picture')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
      }
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _loadUserData(); // Reset to original values
    });
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).updateProfile(_nameController.text, _emailController.text);

      if (success && mounted) {
        // Show success dialog with animation
        SuccessDialog.show(
          context,
          message: 'Profile updated successfully',
          onDismissed: () {
            setState(() {
              _isEditing = false;
            });
          },
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToEditProfile() {
    context.push('/profile/edit');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(6),
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(width: 8),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/More Circle.png',
              width: 24,
              height: 24,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(user),
                  const Divider(height: 32),
                  _buildProfileMenuItems(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey[300] : Colors.grey[600];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Profile image
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child:
                      user.avatar != null
                          ? Image.network(
                            user.avatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                child: Center(
                                  child: Text(
                                    user.name[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: LottieAnimations.getLoadingAnimation(
                                  width: 60,
                                  height: 60,
                                ),
                              );
                            },
                          )
                          : Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            child: Center(
                              child: Text(
                                user.name[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                ),
              ),
              // Add edit icon for profile picture
              // Positioned(
              //   right: 0,
              //   bottom: 0,
              //   child: GestureDetector(
              //     onTap: _pickImage,
              //     child: Container(
              //       padding: const EdgeInsets.all(6),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: const Color(0xFFF85F47),
              //       ),
              //       child: Image.asset(
              //         'assets/icons/Edit.png',
              //         width: 12,
              //         height: 12,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          const SizedBox(width: 16),

          // Name and phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+${user.id} ${user.email}',
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
              ],
            ),
          ),

          // Edit profile button
          GestureDetector(
            onTap: _navigateToEditProfile,
            child: Container(
              padding: const EdgeInsets.all(8),

              child: Image.asset(
                'assets/icons/Edit.png',
                width: 30,
                height: 30,
                color: const Color(0xFFF85F47),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItems(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Column(
      children: [
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Calendar.png',
          icon: Icons.calendar_today_outlined,
          title: 'My Favorite Restaurants',
          textColor: textColor,
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Discount.png',
          icon: Icons.local_offer_outlined,
          title: 'Special Offers & Promo',
          textColor: textColor,
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Wallet.png',
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          textColor: textColor,
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Profile.png',
          icon: Icons.person_outline,
          title: 'Profile',
          textColor: textColor,
          onTap: _navigateToEditProfile,
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Location.png',
          icon: Icons.location_on_outlined,
          title: 'Address',
          textColor: textColor,
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Notification.png',
          icon: Icons.notifications_outlined,
          title: 'Notification',
          textColor: textColor,
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Shield Done.png',
          icon: Icons.security_outlined,
          title: 'Security',
          textColor: textColor,
          onTap: () {},
        ),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return _buildSwitchMenuItem(
              context,
              iconAsset: 'assets/icons/Show.png',
              icon: Icons.visibility_outlined,
              title: 'Dark Mode',
              textColor: textColor,
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            );
          },
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Info Square.png',
          icon: Icons.info_outline,
          title: 'Help Center',
          textColor: textColor,
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/3User.png',
          icon: Icons.people_outline,
          title: 'Invite Friends',
          textColor: textColor,
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          iconAsset: 'assets/icons/Logout.png',
          icon: Icons.logout,
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

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    String? iconAsset,
    required String title,
    Color? textColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading:
          iconAsset != null
              ? Image.asset(
                iconAsset,
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

  Widget _buildSwitchMenuItem(
    BuildContext context, {
    required IconData icon,
    String? iconAsset,
    required String title,
    Color? textColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading:
          iconAsset != null
              ? Image.asset(
                iconAsset,
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
