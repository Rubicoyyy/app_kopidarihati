// Lokasi: lib/data/database/daos/order_dao.dart

import 'package:drift/drift.dart'; // <-- IMPORT PENTING INI
import '../../../models/cart_item.dart';
import '../app_db.dart';

part 'order_dao.g.dart';

@DriftAccessor(tables: [Orders, OrderItems, Products])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(AppDatabase db) : super(db);

  // === CREATE ===
  Future<int> createOrderAndItems(
      String customerName, String tableNumber, List<CartItem> cartItems) async {
    final totalAmount = cartItems.fold(
        0.0, (sum, item) => sum + (item.product.price * item.quantity));

    final orderId = await into(orders).insert(OrdersCompanion.insert(
      customerName: customerName,
      tableNumber: tableNumber,
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
    ));

    for (final item in cartItems) {
      await into(orderItems).insert(OrderItemsCompanion.insert(
        orderId: orderId,
        productId: item.product.id,
        quantity: item.quantity,
        itemPrice: item.product.price,
      ));
    }

    return orderId;
  }

  // === READ ===
  Stream<List<Order>> watchAllOrders() => select(orders).watch();
}