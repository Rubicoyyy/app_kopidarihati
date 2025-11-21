import 'package:drift/drift.dart';
import '../app_db.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(AppDatabase db) : super(db);

  Future<int> insertProduct(Insertable<Product> product) =>
      into(products).insert(product);

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
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.rating, mode: OrderingMode.desc),
          ])
          ..limit(5))
        .watch();
  }

  Stream<List<Product>> searchProducts(String query) {
    return (select(
      products,
    )..where((tbl) => tbl.title.like('%$query%'))).watch();
  }

  Future<bool> updateProduct(Insertable<Product> product) =>
      update(products).replace(product);

  Future<void> toggleFavoriteStatus(Product product) {
    final updatedProduct = ProductsCompanion(
      id: Value(product.id),
      isFavorite: Value(!product.isFavorite),
    );

    return (update(
      products,
    )..where((tbl) => tbl.id.equals(product.id))).write(updatedProduct);
  }

  Future<int> deleteProduct(Insertable<Product> product) =>
      delete(products).delete(product);

  Future<void> seedDatabase() async {
    final allProducts = [
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
      ProductsCompanion.insert(
        title: "Green Tea Latte",
        price: 22000,
        image: 'assets/images/green_tea.jpg',
        rating: 4.9,
        category: 'Tea',
      ),

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

    for (final product in allProducts) {
      final exists =
          await (select(products)
                ..where((tbl) => tbl.title.equals(product.title.value)))
              .getSingleOrNull();

      if (exists == null) {
        await into(products).insert(product);
      }
    }
  }
}
