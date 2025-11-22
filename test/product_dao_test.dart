// Lokasi: test/product_dao_test.dart

import 'package:app_kopidarihati/data/database/app_db.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart'; // Untuk NativeDatabase
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  // Setup: Dijalankan SEBELUM setiap tes dimulai
  setUp(() {
    // Gunakan in-memory database untuk testing (reset setiap test)
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  // Teardown: Dijalankan SETELAH setiap tes selesai
  tearDown(() async {
    await db.close();
  });

  test('Produk bisa ditambahkan dan dibaca', () async {
    // 1. Buat data dummy
    final product = ProductsCompanion.insert(
      title: 'Tes Kopi',
      price: 15000,
      image: 'test.png',
      rating: 4.5,
      category: 'Coffee',
      description: const Value('Deskripsi Tes'),
    );

    // 2. Masukkan ke database
    await db.productDao.insertProduct(product);

    // 3. Baca kembali dari database
    final allProducts = await db.productDao.watchAllProducts().first;

    // 4. Verifikasi
    expect(allProducts.length, 1);
    expect(allProducts.first.title, 'Tes Kopi');
    expect(allProducts.first.price, 15000);
  });

  test('Menghapus produk harus menghilangkan data', () async {
    // 1. Masukkan produk
    final productComp = ProductsCompanion.insert(
      title: 'Tes Hapus',
      price: 10000,
      image: 'img',
      rating: 5,
      category: 'Test',
    );
    await db.productDao.insertProduct(productComp);

    // Pastikan masuk
    var list = await db.productDao.watchAllProducts().first;
    expect(list.length, 1);
    final insertedProduct = list.first;

    // 2. Hapus produk tersebut
    await db.productDao.deleteProduct(insertedProduct);

    // 3. Cek lagi
    list = await db.productDao.watchAllProducts().first;
    expect(list.isEmpty, true);
  });
}