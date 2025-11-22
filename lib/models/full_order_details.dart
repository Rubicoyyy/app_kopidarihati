import '../data/database/app_db.dart'; 

class FullOrderDetails {
  final Order order;
  final List<FullOrderItem> items;

  FullOrderDetails({required this.order, required this.items});
}

class FullOrderItem {
  final OrderItem orderItem;
  final Product product; 

  FullOrderItem({required this.orderItem, required this.product});
}