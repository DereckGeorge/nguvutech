import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/auth_provider.dart';
import '../../../core/widgets/success_dialog.dart';

class ProfileService {
  // Update the user profile
  static Future<bool> updateProfile(
    BuildContext context, {
    required String name,
    required String email,
    VoidCallback? onSuccess,
  }) async {
    try {
      final success = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).updateProfile(name, email);

      if (success && context.mounted) {
        // Show success dialog with animation
        SuccessDialog.show(
          context,
          message: 'Profile updated successfully',
          onDismissed: () {
            if (onSuccess != null) {
              onSuccess();
            }
          },
        );
        return true;
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
        return false;
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      return false;
    }
  }

  // Update the user's avatar
  static Future<bool> updateAvatar(
    BuildContext context, {
    required String imagePath,
    VoidCallback? onSuccess,
  }) async {
    try {
      final success = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).updateAvatar(imagePath);

      if (success && context.mounted) {
        // Show success dialog with animation
        SuccessDialog.show(
          context,
          message: 'Profile picture updated successfully',
          onDismissed: onSuccess,
        );
        return true;
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile picture')),
        );
        return false;
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating avatar: $e')));
      }
      return false;
    }
  }

  // Sign out the user
  static Future<void> signOut(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).signOut();
  }
}
