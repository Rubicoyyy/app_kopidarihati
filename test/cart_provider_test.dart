import 'package:flutter_test/flutter_test.dart';
import 'package:app_kopidarihati/providers/cart_provider.dart';
import 'package:app_kopidarihati/data/database/app_db.dart'; 

void main() {
  group('CartProvider Test', () {
    final productA = Product(
      id: 1,
      title: 'Kopi Tes A',
      price: 10000,
      image: 'test.jpg',
      rating: 5.0,
      category: 'Coffee',
      isFavorite: false,
      description: 'Tes',
    );

    final productB = Product(
      id: 2,
      title: 'Kopi Tes B',
      price: 20000,
      image: 'test.jpg',
      rating: 5.0,
      category: 'Coffee',
      isFavorite: false,
      description: 'Tes',
    );

    test('Keranjang harus kosong saat pertama kali dibuat', () {
      final cart = CartProvider();
      expect(cart.items.length, 0);
      expect(cart.totalAmount, 0);
    });

    test('Menambah produk harus update total harga', () {
      final cart = CartProvider();
      
      cart.addItem(productA);

      expect(cart.itemCount, 1);
      expect(cart.totalAmount, 10000);
    });

    test('Menambah produk yang SAMA harus menambah kuantitas', () {
      final cart = CartProvider();
      
      cart.addItem(productA);
      cart.addItem(productA);

      expect(cart.items.length, 1); 
      expect(cart.itemCount, 2);
      expect(cart.totalAmount, 20000);
    });

    test('Menambah produk BERBEDA harus menambah item baru', () {
      final cart = CartProvider();
      
      cart.addItem(productA); 
      cart.addItem(productB); 

      expect(cart.items.length, 2); 
      expect(cart.totalAmount, 30000); 
    });

    test('Mengurangi kuantitas harus bekerja dengan benar', () {
      final cart = CartProvider();
      
      cart.addItem(productA);
      cart.addItem(productA);
      
      cart.decreaseQuantity(productA);

      expect(cart.itemCount, 1);
      expect(cart.totalAmount, 10000);
    });

    test('Mengurangi item yang sisa 1 harus menghapusnya dari keranjang', () {
      final cart = CartProvider();
      
      cart.addItem(productA); 
      cart.decreaseQuantity(productA); 

      expect(cart.items.isEmpty, true);
      expect(cart.totalAmount, 0);
    });
  });
}