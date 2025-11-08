import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'daos/product_dao.dart';
import 'daos/order_dao.dart';

part 'app_db.g.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get price => real()();
  TextColumn get image => text()();
  RealColumn get rating => real()();
  TextColumn get category => text()();
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
  // Foreign Key ke tabel Orders
  IntColumn get orderId => integer().references(Orders, #id)();
  // Foreign Key ke tabel Products
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get itemPrice => real()(); // Menyimpan harga saat itu
}

@DriftDatabase(
  // Beri tahu database semua tabel yang ada
  tables: [Products, Orders, OrderItems],
  // Beri tahu database semua DAO yang ada
  daos: [ProductDao, OrderDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // NAIKKAN VERSI! (Misal ke 3)

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

  // Hapus semua logika query dari sini,
  // karena sudah dipindahkan ke DAO
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
