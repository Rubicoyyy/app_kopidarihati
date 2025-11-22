import 'package:drift/drift.dart';
import '../app_db.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  Future<User?> login(String username, String password) async {
    return (select(users)..where(
          (tbl) =>
              tbl.username.equals(username) & tbl.password.equals(password),
        ))
        .getSingleOrNull();
  }

  Future<bool> updateUser(User user) => update(users).replace(user);

  Future<void> seedDefaultUsers() async {
    final userCount = await (select(users).get()).then((value) => value.length);
    if (userCount == 0) {
      await batch((batch) {
        batch.insertAll(users, [
          UsersCompanion.insert(
            username: 'admin',
            password: '123', 
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

  Future<bool> registerUser(String username, String password) async {
    final existingUser = await (select(users)
          ..where((tbl) => tbl.username.equals(username)))
        .getSingleOrNull();

    if (existingUser != null) {
      return false; 
    }

    await into(users).insert(UsersCompanion.insert(
      username: username,
      password: password,
      role: 'customer', 
    ));
    
    return true; 
  }
}