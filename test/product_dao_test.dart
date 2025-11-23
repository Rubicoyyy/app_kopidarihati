import 'package:app_kopidarihati/data/database/app_db.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart'; 
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Produk bisa ditambahkan dan dibaca', () async {
    final product = ProductsCompanion.insert(
      title: 'Tes Kopi',
      price: 15000,
      image: 'test.png',
      rating: 4.5,
      category: 'Coffee',
      description: const Value('Deskripsi Tes'),
    );

    await db.productDao.insertProduct(product);

    final allProducts = await db.productDao.watchAllProducts().first;

    expect(allProducts.length, 1);
    expect(allProducts.first.title, 'Tes Kopi');
    expect(allProducts.first.price, 15000);
  });

  test('Menghapus produk harus menghilangkan data', () async {
    final productComp = ProductsCompanion.insert(
      title: 'Tes Hapus',
      price: 10000,
      image: 'img',
      rating: 5,
      category: 'Test',
    );
    await db.productDao.insertProduct(productComp);

    var list = await db.productDao.watchAllProducts().first;
    expect(list.length, 1);
    final insertedProduct = list.first;

    await db.productDao.deleteProduct(insertedProduct);

    list = await db.productDao.watchAllProducts().first;
    expect(list.isEmpty, true);
  });
}