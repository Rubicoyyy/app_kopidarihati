// Lokasi: lib/data/database/daos/product_dao.dart

import 'package:drift/drift.dart';
import '../app_db.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(AppDatabase db) : super(db);

  // === CREATE ===
  Future<int> insertProduct(Insertable<Product> product) =>
      into(products).insert(product);

  // === READ ===
  Stream<List<Product>> watchAllProducts() => select(products).watch();

  Stream<List<Product>> watchFavoriteProducts() {
    return (select(
      products,
    )..where((tbl) => tbl.isFavorite.equals(true))).watch();
  }

  Stream<List<Product>> watchProductsByCategory(String categoryName) {
    if (categoryName == 'All') {
      return select(products).watch();
    } else {
      return (select(
        products,
      )..where((tbl) => tbl.category.equals(categoryName))).watch();
    }
  }

  Stream<List<Product>> watchTopRatedProducts() {
    return (select(products)
          // Urutkan berdasarkan rating, dari tertinggi (desc)
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.rating, mode: OrderingMode.desc)
          ])
          // Batasi hanya 5 produk teratas
          ..limit(5))
        .watch();
  }

  // === UPDATE ===
  Future<bool> updateProduct(Insertable<Product> product) =>
      update(products).replace(product);

  // ===== FUNGSI BARU UNTUK FITUR FAVORIT =====
  Future<void> toggleFavoriteStatus(Product product) {
    // Buat objek pendamping (Companion) hanya dengan data yang ingin diubah
    final updatedProduct = ProductsCompanion(
      id: Value(product.id), // Tentukan id produk yang akan diupdate
      isFavorite: Value(!product.isFavorite), // Balik nilai isFavorite
    );

    // Jalankan perintah update di database
    return (update(
      products,
    )..where((tbl) => tbl.id.equals(product.id))).write(updatedProduct);
  }
  // ===========================================

  // === DELETE ===
  Future<int> deleteProduct(Insertable<Product> product) =>
      delete(products).delete(product);

  // === SEEDING (Data Awal) ===
  Future<void> seedDatabase() async {
    // 1. Siapkan daftar semua produk yang seharusnya ada
    final allProducts = [
      // Kategori: Coffee
      ProductsCompanion.insert(
        title: "Café Latte",
        price: 25000,
        image: 'assets/images/latte.jpg',
        rating: 4.6,
        category: 'Coffee',
      ),
      ProductsCompanion.insert(
        title: "Caffè Americano",
        price: 20000,
        image: 'assets/images/americano.jpg',
        rating: 4.3,
        category: 'Coffee',
      ),
      ProductsCompanion.insert(
        title: "Cappuccino",
        price: 26000,
        image: 'assets/images/cappuccino.jpg',
        rating: 4.8,
        category: 'Coffee',
      ),
      // Kategori: Tea
      ProductsCompanion.insert(
        title: "Green Tea Latte",
        price: 22000,
        image: 'assets/images/green_tea.jpg',
        rating: 4.9,
        category: 'Tea',
      ),
      // Kategori: Food and Snack
      ProductsCompanion.insert(
        title: "Nasi Goreng Medan",
        price: 25000,
        image: 'assets/images/nasi_goreng.jpg',
        rating: 4.7,
        category: 'Food and Snack',
      ),
      ProductsCompanion.insert(
        title: "Mie Bangladesh",
        price: 15000,
        image: 'assets/images/mie_bangladesh.jpg',
        rating: 4.8,
        category: 'Food and Snack',
      ),
      ProductsCompanion.insert(
        title: "French Fries",
        price: 20000,
        image: 'assets/images/french_fries.jpg',
        rating: 4.5,
        category: 'Food and Snack',
      ),
      ProductsCompanion.insert(
        title: "Nugget",
        price: 28000,
        image: 'assets/images/nugget.jpg',
        rating: 4.4,
        category: 'Food and Snack',
      ),
      ProductsCompanion.insert(
        title: "Sosis Goreng",
        price: 30000,
        image: 'assets/images/sosis_goreng.jpg',
        rating: 4.5,
        category: 'Food and Snack',
      ),
      ProductsCompanion.insert(
        title: "Mix Fritters",
        price: 35000,
        image: 'assets/images/mix_fritters.jpg',
        rating: 4.6,
        category: 'Food and Snack',
      ),
      ProductsCompanion.insert(
        title: "Singkong Goreng",
        price: 15000,
        image: 'assets/images/singkong_goreng.jpg',
        rating: 4.6,
        category: 'Food and Snack',
      ),
      // Kategori: Non Coffee
      ProductsCompanion.insert(
        title: "Red Velvet (Ice)",
        price: 25000,
        image: 'assets/images/red_velvet_ice.jpg',
        rating: 4.8,
        category: 'Non Coffee',
      ),
      ProductsCompanion.insert(
        title: "Red Velvet (Hot)",
        price: 15000,
        image: 'assets/images/red_velvet_hot.jpg',
        rating: 4.7,
        category: 'Non Coffee',
      ),
    ];

    // 2. Loop setiap produk di daftar
    for (final product in allProducts) {
      // 3. Cek apakah produk dengan judul ini sudah ada di database
      final exists =
          await (select(products)
                ..where((tbl) => tbl.title.equals(product.title.value)))
              .getSingleOrNull();

      // 4. Jika 'exists' bernilai null (belum ada), maka masukkan
      if (exists == null) {
        await into(products).insert(product);
      }
      // 5. Jika sudah ada, loop akan lanjut ke produk berikutnya (tidak melakukan apa-apa)
    }
  }
}
