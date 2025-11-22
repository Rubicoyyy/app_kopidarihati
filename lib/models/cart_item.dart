import '../data/database/app_db.dart';

class CartItem {
  final String id;
  final Product product; 
  int quantity;

  CartItem({required this.id, required this.product, this.quantity = 1});
}
