// Lokasi: lib/data/database/app_db.dart

import 'dart:io';
// ===== INI IMPORT YANG HILANG =====
import 'package:drift/drift.dart';
// ===================================
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import semua DAO
import 'daos/product_dao.dart';
import 'daos/order_dao.dart';
import 'daos/user_dao.dart';

part 'app_db.g.dart'; // File generated

// --- DEFINISI TABEL ---

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get price => real()();
  TextColumn get image => text()();
  RealColumn get rating => real()();
  TextColumn get category => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

@DataClassName('Order')
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName => text()();
  TextColumn get tableNumber => text()();
  RealColumn get totalAmount => real()();
  DateTimeColumn get orderDate => dateTime()();
}

@DataClassName('OrderItem')
class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get itemPrice => real()();
}

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get password => text()();
  TextColumn get role => text()(); // "admin" atau "customer"
}

// --- KELAS DATABASE UTAMA ---

@DriftDatabase(
  tables: [Products, Orders, OrderItems, Users],
  daos: [ProductDao, OrderDao, UserDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5; // Versi 5

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        // Hapus semua tabel lama
        for (final table in allTables) {
          await migrator.deleteTable(table.actualTableName);
        }
        // Buat ulang semua tabel baru
        await migrator.createAll();
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}