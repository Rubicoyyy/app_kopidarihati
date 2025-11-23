import 'package:app_kopidarihati/data/database/app_db.dart';
import 'package:app_kopidarihati/providers/cart_provider.dart';
import 'package:app_kopidarihati/screens/add_product_page.dart';
import 'package:app_kopidarihati/screens/cart_page.dart';
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

  testWidgets(
    'AddProductPage harus memunculkan error jika form kosong disimpan',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MultiProvider(
          providers: [Provider<AppDatabase>.value(value: db)],
          child: const MaterialApp(home: AddProductPage()),
        ),
      );

      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(ElevatedButton, 'SIMPAN PRODUK');

      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      await tester.tap(saveButton);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.textContaining('Wajib diisi'), findsAtLeastNWidgets(1));
    },
  );

  testWidgets('Tombol Plus (+) di CartPage harus menambah kuantitas item', (
    WidgetTester tester,
  ) async {
    final dummyProduct = Product(
      id: 1,
      title: 'Kopi Test',
      price: 10000,
      image: 'assets/images/latte.jpg',
      rating: 5,
      category: 'Test',
      isFavorite: false,
      description: 'desc',
    );

    cartProvider.addItem(dummyProduct);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          Provider<AppDatabase>.value(value: db),
        ],
        child: const MaterialApp(home: CartPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('1'), findsAtLeastNWidgets(1));

    final addButton = find.byIcon(Icons.add_circle_outline);

    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.text('2'), findsAtLeastNWidgets(1));
  });
}
