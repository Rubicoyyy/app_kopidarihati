// Lokasi: lib/models/cart_item.dart

import '../data/database/app_db.dart';

class CartItem {
  final String id;
  final Product product; // Sekarang ini adalah Product dari Drift
  int quantity;

  CartItem({required this.id, required this.product, this.quantity = 1});
}
