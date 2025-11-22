import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/database/app_db.dart';
import '../models/full_order_details.dart';
import '../widgets/universal_image.dart'; 

class AdminOrderPage extends StatelessWidget {
  const AdminOrderPage({super.key});

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Menunggu';
      case 1:
        return 'Diproses';
      case 2:
        return 'Selesai';
      case 3:
        return 'Batal';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd MMM HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dapur (Pesanan Masuk)',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<List<FullOrderDetails>>(
        stream: db.orderDao.watchFullOrderHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('Belum ada pesanan masuk.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final fullOrder = orders[index];
              final order = fullOrder.order;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Text(
                        '#${order.id} ${order.customerName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getStatusColor(order.status),
                          ),
                        ),
                        child: Text(
                          _getStatusText(order.status),
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meja: ${order.tableNumber} • ${dateFormatter.format(order.orderDate)}',
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Total: ${currencyFormatter.format(order.totalAmount)}', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'Metode: ${order.paymentMethod}', 
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      
                    ],
                  ),
                  children: [
                    // Daftar Item
                    ...fullOrder.items.map(
                      (item) => ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: UniversalImage(
                              item.product.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(item.product.title),
                        trailing: Text('${item.orderItem.quantity}x'),
                        dense: true,
                      ),
                    ),

                    const Divider(),

                    // Tombol Aksi Admin
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (order.status == 0)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.coffee_maker, size: 16),
                              label: const Text("Proses"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () =>
                                  db.orderDao.updateOrderStatus(order.id, 1),
                            ),
                          if (order.status == 1)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle, size: 16),
                              label: const Text("Selesai"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () =>
                                  db.orderDao.updateOrderStatus(order.id, 2),
                            ),
                          if (order.status != 3 && order.status != 2)
                            TextButton.icon(
                              icon: const Icon(Icons.cancel, size: 16),
                              label: const Text("Tolak"),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () =>
                                  db.orderDao.updateOrderStatus(order.id, 3),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
