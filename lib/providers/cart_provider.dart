// Lokasi: lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../data/database/app_db.dart'; 
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  // Perhatikan tipe parameter 'product' sekarang adalah Product dari Drift
  void addItem(Product product) {
    if (_items.containsKey(product.title)) {
      _items.update(
        product.title,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.title,
        () => CartItem(id: DateTime.now().toString(), product: product),
      );
    }
    notifyListeners();
  }

  void removeItem(String productTitle) {
      _items.remove(productTitle);
      // Beri tahu UI untuk update setelah item dihapus
      notifyListeners();
    }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
