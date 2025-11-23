import 'package:app_kopidarihati/data/database/app_db.dart';
import 'package:app_kopidarihati/providers/cart_provider.dart';
import 'package:app_kopidarihati/screens/cart_page.dart';
import 'package:app_kopidarihati/screens/login_page.dart';
import 'package:app_kopidarihati/widgets/product_card.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late AppDatabase db;
  late CartProvider cartProvider;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    cartProvider = CartProvider();
  });

  tearDown(() async {
    await db.close();
  });


  test('Unit Test: OrderDao menghitung total item dengan benar', () async {
    await db.productDao.seedDatabase(); 
    final products = await db.productDao.watchAllProducts().first;
    final productA = products[0]; 

    cartProvider.addItem(productA);
    cartProvider.addItem(productA); 

    final orderId = await db.orderDao.createOrderAndItems(
      'Budi',
      '12',
      'Tunai',
      cartProvider.items.values.toList(),
    );

    final savedOrders = await db.orderDao.watchAllOrders().first;
    final myOrder = savedOrders.firstWhere((o) => o.id == orderId);

    expect(myOrder.totalAmount, 50000.0);
    expect(myOrder.customerName, 'Budi');
  });

  test('Unit Test: CartProvider clearCart benar-benar mengosongkan item', () {
    final dummyProduct = Product(
      id: 1,
      title: 'Kopi Test',
      price: 10000,
      image: 'test.png',
      rating: 5,
      category: 'Test',
      isFavorite: false,
      description: 'desc',
    );
    cartProvider.addItem(dummyProduct);

    expect(cartProvider.itemCount, 1);

    cartProvider.clearCart();

    expect(cartProvider.itemCount, 0);
    expect(cartProvider.items.isEmpty, true);
  });

 
  // WIDGET TESTING (TAMPILAN UI)
 
  testWidgets('Widget Test: LoginPage menampilkan elemen input yang benar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Kopi Dari Hati'), findsOneWidget);

    expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);

    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets(
    'Widget Test: ProductCardWidget menampilkan data produk dengan benar',
    (WidgetTester tester) async {
      final dummyProduct = Product(
        id: 99,
        title: 'Kopi Spesial Unit Test',
        price: 55000,
        image: 'assets/images/latte.jpg', 
        rating: 4.9,
        category: 'Coffee',
        isFavorite: true, 
        description: 'Deskripsi Test',
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [Provider<AppDatabase>.value(value: db)],
          child: MaterialApp(
            home: Scaffold(body: ProductCardWidget(product: dummyProduct)),
          ),
        ),
      );

      expect(find.text('Kopi Spesial Unit Test'), findsOneWidget);

      expect(find.textContaining('55000'), findsOneWidget);

      expect(find.text('4.9'), findsOneWidget);

      final iconFinder = find.byIcon(Icons.favorite);
      expect(iconFinder, findsOneWidget);

      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, Colors.red);
    },
  );

  testWidgets(
    'Widget Test: CartPage menampilkan pesan kosong jika tidak ada item',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
          ],
          child: const MaterialApp(home: CartPage()),
        ),
      );

      expect(find.text('Keranjang Anda masih kosong.'), findsOneWidget);

      expect(find.text('Pesan Sekarang'), findsNothing);
    },
  );
}
