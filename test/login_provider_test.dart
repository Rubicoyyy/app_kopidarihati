// Lokasi: test/login_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart'; // Untuk in-memory database
import 'package:app_kopidarihati/data/database/app_db.dart';
import 'package:app_kopidarihati/providers/login_provider.dart';

void main() {
  late AppDatabase db;
  late LoginProvider loginProvider;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    loginProvider = LoginProvider(db);

    await loginProvider.init();
  });

  tearDown(() async {
    await db.close();
  });

  group('LoginProvider Test', () {
    test('Awalnya user belum login', () {
      expect(loginProvider.isLoggedIn, false);
      expect(loginProvider.currentUser, null);
    });

    test('Bisa register user baru', () async {
      // Register user baru
      final success = await loginProvider.register('testuser', '123456');

      expect(success, true);
      expect(loginProvider.isLoggedIn, true);
      expect(loginProvider.currentUser?.username, 'testuser');
    });

    test('Tidak bisa register dengan username yang sama', () async {
      await loginProvider.register('userA', '123');

      // Coba register lagi dengan nama sama
      final success = await loginProvider.register('userA', '999');

      expect(success, false); // Harusnya gagal
      expect(loginProvider.loginError, isNotEmpty);
    });

    test('Login gagal jika password salah', () async {
      await loginProvider.register('userB', 'passwordBenar');
      // Logout dulu
      loginProvider.logout();

      // Coba login password salah
      final success = await loginProvider.login('userB', 'passwordSalah');

      expect(success, false);
      expect(loginProvider.isLoggedIn, false);
    });

    test('Login sukses jika username & password benar', () async {
      await loginProvider.register('userC', 'rahasia');
      loginProvider.logout();

      final success = await loginProvider.login('userC', 'rahasia');

      expect(success, true);
      expect(loginProvider.isLoggedIn, true);
    });
  });
}
