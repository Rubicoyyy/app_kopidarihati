import 'package:flutter/material.dart';
import '../data/database/app_db.dart';

class LoginProvider with ChangeNotifier {
  final AppDatabase _db;

  LoginProvider(this._db);

  Future<void> init() async {
    await _db.userDao.seedDefaultUsers();
  }

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  String _loginError = '';
  String get loginError => _loginError;

  Future<bool> login(String username, String password) async {
    _loginError = '';

    final user = await _db.userDao.login(username, password);

    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    } else {
      _loginError = 'Username atau password salah!';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    _loginError = '';

    final success = await _db.userDao.registerUser(username, password);

    if (success) {
      await login(username, password);
      return true;
    } else {
      _loginError = 'Username sudah digunakan, coba yang lain.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String newUsername, String newPassword) async {
    if (_currentUser == null) return false;

    final updatedUser = User(
      id: _currentUser!.id,
      username: newUsername,
      password: newPassword,
      role: _currentUser!.role,
    );

    final success = await _db.userDao.updateUser(updatedUser);

    if (success) {
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
