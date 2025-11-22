import 'package:flutter/material.dart';
import '../data/database/app_db.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

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
        () => CartItem(
          id: DateTime.now().toString(),
          product: product,
          quantity: 1, 
        ),
      );
    }
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    if (!_items.containsKey(product.title)) return;

    if (_items[product.title]!.quantity > 1) {
      _items.update(
        product.title,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(product.title);
    }
    notifyListeners();
  }

  void removeItem(String productTitle) {
    _items.remove(productTitle);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
