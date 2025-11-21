// Lokasi: lib/data/database/daos/user_dao.dart

import 'package:drift/drift.dart';
import '../app_db.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  // Fungsi untuk Login
  // Mengembalikan User jika sukses, null jika gagal
  Future<User?> login(String username, String password) async {
    return (select(users)..where(
          (tbl) =>
              tbl.username.equals(username) & tbl.password.equals(password),
        ))
        .getSingleOrNull();
  }

  // Fungsi untuk Seeding (Membuat akun default)
  Future<void> seedDefaultUsers() async {
    final userCount = await (select(users).get()).then((value) => value.length);
    if (userCount == 0) {
      // Buat 1 Admin dan 1 Customer
      await batch((batch) {
        batch.insertAll(users, [
          UsersCompanion.insert(
            username: 'admin',
            password: '123', // Peringatan: SANGAT TIDAK AMAN
            role: 'admin',
          ),
          UsersCompanion.insert(
            username: 'customer',
            password: '123',
            role: 'customer',
          ),
        ]);
      });
    }
  }
}
