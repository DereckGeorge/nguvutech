
import '../models/user_model.dart';

class MockDataService {
  // Singleton instance
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final List<UserModel> _users = [
    UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      role: 'Admin',
      avatar: 'https://ui-avatars.com/api/?name=John+Doe&background=random',
      isActive: true,
    ),
    UserModel(
      id: '2',
      name: 'Jane Smith',
      email: 'jane@example.com',
      role: 'Editor',
      avatar: 'https://ui-avatars.com/api/?name=Jane+Smith&background=random',
      isActive: true,
    ),
    UserModel(
      id: '3',
      name: 'Bob Johnson',
      email: 'bob@example.com',
      role: 'User',
      avatar: 'https://ui-avatars.com/api/?name=Bob+Johnson&background=random',
      isActive: true,
    ),
    UserModel(
      id: '4',
      name: 'Alice Brown',
      email: 'alice@example.com',
      role: 'User',
      avatar: 'https://ui-avatars.com/api/?name=Alice+Brown&background=random',
      isActive: false,
    ),
    UserModel(
      id: '5',
      name: 'Charlie Davis',
      email: 'charlie@example.com',
      role: 'Editor',
      avatar:
          'https://ui-avatars.com/api/?name=Charlie+Davis&background=random',
      isActive: true,
    ),
    UserModel(
      id: '6',
      name: 'Eva Wilson',
      email: 'eva@example.com',
      role: 'User',
      avatar: 'https://ui-avatars.com/api/?name=Eva+Wilson&background=random',
      isActive: true,
    ),
  ];

  // Get all users
  List<UserModel> getAllUsers() {
    return List.from(_users);
  }

  // Get users by role
  List<UserModel> getUsersByRole(String role) {
    if (role == 'All Roles') {
      return List.from(_users);
    }
    return _users.where((user) => user.role == role).toList();
  }

  // Get user by id
  UserModel? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add user
  UserModel addUser(UserModel user) {
    final newUser = user.copyWith(
      id: (int.parse(_users.last.id) + 1).toString(),
    );
    _users.add(newUser);
    return newUser;
  }

  // Update user
  UserModel updateUser(UserModel user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index >= 0) {
      _users[index] = user;
      return user;
    }
    throw Exception('User not found');
  }

  // Delete user
  void deleteUser(String id) {
    _users.removeWhere((user) => user.id == id);
  }

  // Search users
  List<UserModel> searchUsers(String query) {
    final lowerCaseQuery = query.toLowerCase();
    return _users
        .where(
          (user) =>
              user.name.toLowerCase().contains(lowerCaseQuery) ||
              user.email.toLowerCase().contains(lowerCaseQuery),
        )
        .toList();
  }

  // Toggle user active status
  UserModel toggleUserActiveStatus(String id) {
    final index = _users.indexWhere((user) => user.id == id);
    if (index >= 0) {
      final user = _users[index];
      final updatedUser = user.copyWith(isActive: !user.isActive);
      _users[index] = updatedUser;
      return updatedUser;
    }
    throw Exception('User not found');
  }
}
