import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'mock_data_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';

  final MockDataService _dataService = MockDataService();
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  AuthProvider() {
    _checkAuthentication();
  }

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _isLoading;

  // Update the status and notify listeners
  void _updateStatus(AuthStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      debugPrint('Auth status changed to $_status');
      notifyListeners();
    }
  }

  // Check if user is authenticated
  Future<void> _checkAuthentication() async {
    _setLoading(true);
    try {
      debugPrint('Checking authentication...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(authTokenKey);
      final userId = prefs.getString(userIdKey);

      if (token != null && userId != null) {
        debugPrint('Token and userId found in SharedPreferences');
        final user = _dataService.getUserById(userId);
        if (user != null) {
          _token = token;
          _user = user;
          _updateStatus(AuthStatus.authenticated);
          debugPrint('User authenticated: ${_user?.name}');
          return;
        }
      }
      _updateStatus(AuthStatus.unauthenticated);
      debugPrint('User not authenticated');
    } catch (e) {
      debugPrint('Error checking authentication: $e');
      _updateStatus(AuthStatus.unauthenticated);
    } finally {
      _setLoading(false);
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      // In a real app, you would make API calls here
      // For this demo, we'll simulate authentication
      debugPrint('Attempting to sign in with email: $email');
      await Future.delayed(const Duration(seconds: 1));

      // Find user by email (mock implementation)
      final users = _dataService.getAllUsers();
      debugPrint('Found ${users.length} users');

      if (users.isEmpty) {
        debugPrint('No users available in mock data');
        return false;
      }

      final userExists = users.any(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
      if (!userExists) {
        debugPrint('User with email $email not found');
        return false;
      }

      final user = users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      debugPrint('Found user: ${user.name} with email: ${user.email}');

      // For demo purposes, accept any password for now
      // In real app, password would be hashed and compared

      // Generate mock token
      final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('Generated token: $token');

      // Save auth data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(authTokenKey, token);
      await prefs.setString(userIdKey, user.id);

      debugPrint('Saved auth data to SharedPreferences');

      _token = token;
      _user = user;
      _updateStatus(AuthStatus.authenticated);

      debugPrint('User authenticated successfully');
      return true;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign up
  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);
    try {
      // In a real app, you would make API calls here
      // For this demo, we'll simulate registration
      await Future.delayed(const Duration(seconds: 1));

      // Create new user (with default role as 'User')
      final newUser = UserModel(
        id: '', // ID will be assigned by addUser method
        name: name,
        email: email,
        role: 'User',
        avatar:
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random',
      );

      final createdUser = _dataService.addUser(newUser);

      // Generate mock token
      final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save auth data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(authTokenKey, token);
      await prefs.setString(userIdKey, createdUser.id);

      _token = token;
      _user = createdUser;
      _updateStatus(AuthStatus.authenticated);

      return true;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(authTokenKey);
      await prefs.remove(userIdKey);

      _token = null;
      _user = null;
      _updateStatus(AuthStatus.unauthenticated);
    } catch (e) {
      debugPrint('Sign out error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile(String name, String email) async {
    if (_user == null) return false;

    _setLoading(true);
    try {
      final updatedUser = _user!.copyWith(name: name, email: email);

      final user = _dataService.updateUser(updatedUser);
      _user = user;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    _setLoading(true);
    try {
      // In a real app, you would validate the current password and update it
      // For this demo, we'll just simulate success
      await Future.delayed(const Duration(seconds: 1));

      // Check if current password is correct (mock implementation)
      if (currentPassword != '123456') {
        return false;
      }

      // In a real app, you would update the password in the backend

      return true;
    } catch (e) {
      debugPrint('Change password error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
