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

  Stream<List<Product>> watchProductsByCategory(String categoryName) {
    if (categoryName == 'All') {
      return select(products).watch();
    } else {
      return (select(
        products,
      )..where((tbl) => tbl.category.equals(categoryName))).watch();
    }
  }

  // === UPDATE ===
  Future<bool> updateProduct(Insertable<Product> product) =>
      update(products).replace(product);

  // === DELETE ===
  Future<int> deleteProduct(Insertable<Product> product) =>
      delete(products).delete(product);

  // === SEEDING (Data Awal) ===
  Future<void> seedDatabase() async {
    final count = await (select(products).get()).then((value) => value.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(products, [
          // KATEGORI: Coffee (Diperbarui dengan path aset lokal)
          ProductsCompanion.insert(
            title: "Café Latte",
            price: 25000,
            image: 'assets/images/latte.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.6,
            category: 'Coffee',
          ),
          ProductsCompanion.insert(
            title: "Caffè Americano",
            price: 20000,
            image:
                'assets/images/americano.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.3,
            category: 'Coffee',
          ),
          ProductsCompanion.insert(
            title: "Cappuccino",
            price: 26000,
            image:
                'assets/images/cappuccino.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.8,
            category: 'Coffee',
          ),

          // KATEGORI: Tea (Diperbarui dengan path aset lokal)
          ProductsCompanion.insert(
            title: "Green Tea Latte",
            price: 22000,
            image:
                'assets/images/green_tea.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.9,
            category: 'Tea',
          ),

          // KATEGORI BARU: Food and Snack
          ProductsCompanion.insert(
            title: "Nasi Goreng Medan",
            price: 25000,
            image:
                'assets/images/nasi_goreng.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.7,
            category: 'Food and Snack',
          ),
          ProductsCompanion.insert(
            title: "Mie Bangladesh",
            price: 15000,
            image:
                'assets/images/mie_bangladesh.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.8,
            category: 'Food and Snack',
          ),
          ProductsCompanion.insert(
            title: "French Fries",
            price: 20000,
            image:
                'assets/images/french_fries.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.5,
            category: 'Food and Snack',
          ),
          ProductsCompanion.insert(
            title: "Nugget",
            price: 28000,
            image: 'assets/images/nugget.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.4,
            category: 'Food and Snack',
          ),
          ProductsCompanion.insert(
            title: "Sosis Goreng",
            price: 30000,
            image:
                'assets/images/sosis_goreng.jpg', // GANTI NAMA FILENYA JIKA BEDA
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

          // KATEGORI BARU: Non Coffee (Dipisah)
          ProductsCompanion.insert(
            title: "Red Velvet (Ice)",
            price: 25000,
            image:
                'assets/images/red_velvet_ice.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.8,
            category: 'Non Coffee',
          ),
          ProductsCompanion.insert(
            title: "Red Velvet (Hot)",
            price: 15000,
            image:
                'assets/images/red_velvet_hot.jpg', // GANTI NAMA FILENYA JIKA BEDA
            rating: 4.7,
            category: 'Non Coffee',
          ),
        ]);
      });
    }
  }
}
