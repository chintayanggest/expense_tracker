import 'package:flutter/material.dart';
import '../models/unified_models.dart';
import '../services/database_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<String?> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
        profilePath: null,
      );
      await DatabaseHelper.instance.createUser(newUser);
      _user = newUser;
      return null;
    } catch (e) {
      return "Registration failed: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await DatabaseHelper.instance.getUser(email, password);
      if (user != null) {
        _user = user;
        return null;
      } else {
        return "Invalid email or password";
      }
    } catch (e) {
      return "Login error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- UPDATE PROFILE LOGIC ---
  Future<void> updateProfile(String name, String? imagePath) async {
    if (_user == null) return;

    // Create new user object with updated info
    final updatedUser = _user!.copyWith(name: name, profilePath: imagePath);

    // Save to DB
    await DatabaseHelper.instance.updateUser(updatedUser);

    // Update local state
    _user = updatedUser;
    notifyListeners();
  }

  // --- DELETE ACCOUNT LOGIC ---
  Future<void> deleteAccount() async {
    if (_user == null) return;
    await DatabaseHelper.instance.deleteUser(_user!.id);
    _user = null;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}