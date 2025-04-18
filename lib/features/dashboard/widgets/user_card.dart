import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/user_provider.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 1,
              onPressed: (_) {
                // Edit user
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              flex: 1,
              onPressed: (_) {
                _toggleUserStatus(context);
              },
              backgroundColor: user.isActive ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
              icon: user.isActive ? Icons.block : Icons.check_circle,
              label: user.isActive ? 'Suspend' : 'Activate',
            ),
            SlidableAction(
              flex: 1,
              onPressed: (_) {
                _deleteUser(context);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child:
                        user.avatar != null
                            ? CachedNetworkImage(
                              imageUrl: user.avatar!,
                              placeholder:
                                  (context, url) =>
                                      const CircularProgressIndicator(),
                              errorWidget:
                                  (context, url, error) => Text(
                                    user.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            )
                            : Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                  ),
                ),
                const SizedBox(width: 12),

                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(context, user.role),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user.role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Status indicator
                if (!user.isActive) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Suspended',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                // More options button
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    _showMoreOptions(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  Color _getRoleColor(BuildContext context, String role) {
    switch (role) {
      case 'Admin':
        return Colors.purple;
      case 'Editor':
        return Colors.blue;
      case 'User':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  void _toggleUserStatus(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(user.isActive ? 'Suspend User' : 'Activate User'),
            content: Text(
              user.isActive
                  ? 'Are you sure you want to suspend ${user.name}?'
                  : 'Are you sure you want to activate ${user.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).toggleUserActiveStatus(user.id);
                },
                child: Text(user.isActive ? 'Suspend' : 'Activate'),
              ),
            ],
          ),
    );
  }

  void _deleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete User'),
            content: Text('Are you sure you want to delete ${user.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).deleteUser(user.id);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit User'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to edit user
                  },
                ),
                ListTile(
                  leading: Icon(
                    user.isActive ? Icons.block : Icons.check_circle,
                  ),
                  title: Text(user.isActive ? 'Suspend User' : 'Activate User'),
                  onTap: () {
                    Navigator.pop(context);
                    _toggleUserStatus(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete User',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteUser(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
