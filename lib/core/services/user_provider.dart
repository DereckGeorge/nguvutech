import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import 'mock_data_service.dart';

class UserProvider extends ChangeNotifier {
  final MockDataService _dataService = MockDataService();
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  String _selectedRole = 'All Roles';
  String _searchQuery = '';
  UserModel? _currentUser;
  bool _isLoading = false;

  UserProvider() {
    _loadUsers();

    // Set default values - actual values will be loaded asynchronously
    _filteredUsers = [];

    // Current user will be set after data is loaded
    debugPrint('UserProvider initialized');
  }

  // Getters
  List<UserModel> get users => _filteredUsers;
  String get selectedRole => _selectedRole;
  String get searchQuery => _searchQuery;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Load users
  Future<void> _loadUsers() async {
    _setLoading(true);
    try {
      debugPrint('Loading users from mock data service');
      _users = _dataService.getAllUsers();
      _applyFilters();

      // Set current user after data is loaded
      if (_users.isNotEmpty) {
        _currentUser = _users.firstWhere(
          (user) => user.role == 'Admin',
          orElse: () => _users.first,
        );
        debugPrint('Current user set to: ${_currentUser?.name}');
      } else {
        debugPrint('No users available in mock data');
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Apply filters (role and search)
  void _applyFilters() {
    if (_selectedRole == 'All Roles' && _searchQuery.isEmpty) {
      _filteredUsers = List.from(_users);
    } else {
      _filteredUsers = _users;

      // Filter by role
      if (_selectedRole != 'All Roles') {
        _filteredUsers =
            _filteredUsers.where((user) => user.role == _selectedRole).toList();
      }

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        _filteredUsers =
            _filteredUsers
                .where(
                  (user) =>
                      user.name.toLowerCase().contains(query) ||
                      user.email.toLowerCase().contains(query),
                )
                .toList();
      }
    }
    notifyListeners();
  }

  // Filter by role
  void filterByRole(String role) {
    _selectedRole = role;
    _applyFilters();
  }

  // Search users
  void searchUsers(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Add user
  Future<UserModel> addUser(UserModel user) async {
    _setLoading(true);
    try {
      final newUser = _dataService.addUser(user);
      _users.add(newUser);
      _applyFilters();
      return newUser;
    } finally {
      _setLoading(false);
    }
  }

  // Update user
  Future<UserModel> updateUser(UserModel user) async {
    _setLoading(true);
    try {
      final updatedUser = _dataService.updateUser(user);
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index >= 0) {
        _users[index] = updatedUser;
      }

      // Update current user if it's the same user
      if (_currentUser != null && _currentUser!.id == user.id) {
        _currentUser = updatedUser;
      }

      _applyFilters();
      return updatedUser;
    } finally {
      _setLoading(false);
    }
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    _setLoading(true);
    try {
      _dataService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      _applyFilters();
    } finally {
      _setLoading(false);
    }
  }

  // Toggle user active status
  Future<UserModel> toggleUserActiveStatus(String id) async {
    _setLoading(true);
    try {
      final updatedUser = _dataService.toggleUserActiveStatus(id);
      final index = _users.indexWhere((user) => user.id == id);
      if (index >= 0) {
        _users[index] = updatedUser;
      }
      _applyFilters();
      return updatedUser;
    } finally {
      _setLoading(false);
    }
  }

  // Set current user - for demo purpose
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }
}
