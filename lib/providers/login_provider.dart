// Lokasi: lib/providers/login_provider.dart

import 'package:flutter/material.dart';
import '../data/database/app_db.dart'; // Kita butuh model User

class LoginProvider with ChangeNotifier {
  final AppDatabase _db;
  
  LoginProvider(this._db) {
    // Saat provider dibuat, langsung isi database dengan user default
    _db.userDao.seedDefaultUsers();
  }

  User? _currentUser; // Pengguna yang sedang login
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  String _loginError = '';
  String get loginError => _loginError;

  // Fungsi untuk mencoba login
  Future<bool> login(String username, String password) async {
    _loginError = ''; // Bersihkan error
    
    final user = await _db.userDao.login(username, password);

    if (user != null) {
      _currentUser = user; // Sukses! Simpan data user
      notifyListeners();
      return true;
    } else {
      _loginError = 'Username atau password salah!'; // Gagal
      notifyListeners();
      return false;
    }
  }

  // Fungsi untuk logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}