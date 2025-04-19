import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../../core/models/user_model.dart';
import '../../../core/utils/lottie_animations.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEditProfile;
  final VoidCallback onEditImage;

  const ProfileHeader({
    Key? key,
    required this.user,
    required this.onEditProfile,
    required this.onEditImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onTap: onEditProfile,
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
}
