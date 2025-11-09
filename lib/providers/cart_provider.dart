// Lokasi: lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../data/database/app_db.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount {
    // Menghitung total jumlah item, bukan hanya jenis item
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  // Fungsi ini sudah benar, ia akan menambah kuantitas
  void addItem(Product product) {
    if (_items.containsKey(product.title)) {
      // Jika produk sudah ada, tambah kuantitasnya
      _items.update(
        product.title,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // Jika produk baru, tambahkan dengan kuantitas 1
      _items.putIfAbsent(
        product.title,
        () => CartItem(
          id: DateTime.now().toString(),
          product: product,
          quantity: 1, // Kuantitas awal
        ),
      );
    }
    notifyListeners();
  }

  // ===== TAMBAHKAN FUNGSI BARU INI =====
  void decreaseQuantity(Product product) {
    // Cek apakah item ada di keranjang
    if (!_items.containsKey(product.title)) return;

    if (_items[product.title]!.quantity > 1) {
      // Jika kuantitas lebih dari 1, kurangi 1
      _items.update(
        product.title,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      // Jika kuantitas sisa 1, hapus item dari keranjang
      _items.remove(product.title);
    }
    notifyListeners();
  }
  // ======================================

  // Fungsi ini untuk swipe-to-delete (menghapus semua)
  void removeItem(String productTitle) {
    _items.remove(productTitle);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
