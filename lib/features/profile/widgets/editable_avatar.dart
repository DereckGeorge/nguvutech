import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/models/user_model.dart';
import '../../../core/utils/lottie_animations.dart';

class EditableAvatar extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;

  const EditableAvatar({Key? key, required this.user, required this.onEdit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
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
              borderRadius: BorderRadius.circular(50),
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
                                  color: Theme.of(context).colorScheme.primary,
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
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF85F47),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/icons/Edit.png',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
