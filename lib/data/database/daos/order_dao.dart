import 'package:drift/drift.dart';
import '../../../models/cart_item.dart';
import '../app_db.dart';
import '../../../models/full_order_details.dart';

part 'order_dao.g.dart';

@DriftAccessor(tables: [Orders, OrderItems, Products])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(AppDatabase db) : super(db);

  Future<int> createOrderAndItems(
    String customerName,
    String tableNumber,
    List<CartItem> cartItems,
  ) async {
    final totalAmount = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    final orderId = await into(orders).insert(
      OrdersCompanion.insert(
        customerName: customerName,
        tableNumber: tableNumber,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
      ),
    );

    for (final item in cartItems) {
      await into(orderItems).insert(
        OrderItemsCompanion.insert(
          orderId: orderId,
          productId: item.product.id,
          quantity: item.quantity,
          itemPrice: item.product.price,
        ),
      );
    }
    return orderId;
  }

  Stream<List<Order>> watchAllOrders() => select(orders).watch();

  Stream<List<FullOrderDetails>> watchFullOrderHistory() {
    final ordersStream =
        (select(orders)..orderBy([
              (o) => OrderingTerm(
                expression: o.orderDate,
                mode: OrderingMode.desc,
              ),
            ]))
            .watch();

    return ordersStream.asyncMap((ordersList) async {
      final List<FullOrderDetails> fullOrders = [];

      for (final order in ordersList) {
        final itemsQuery = select(orderItems)
          ..where((item) => item.orderId.equals(order.id));

        final List<OrderItem> items = await itemsQuery.get();
        final List<FullOrderItem> fullItems = [];

        for (final item in items) {
          final productQuery = select(products)
            ..where((prod) => prod.id.equals(item.productId));

          final Product product = await productQuery.getSingle();

          fullItems.add(FullOrderItem(orderItem: item, product: product));
        }

        fullOrders.add(FullOrderDetails(order: order, items: fullItems));
      }
      return fullOrders;
    });
  }

}
