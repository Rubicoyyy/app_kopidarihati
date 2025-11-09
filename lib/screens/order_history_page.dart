// Lokasi: lib/screens/order_history_page.dart

import 'package:app_kopidarihati/models/full_order_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// PERBAIKAN: Path import ini sudah benar
import 'package:provider/provider.dart';
import '../data/database/app_db.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    // Formatter untuk tanggal (Contoh: 09 Nov 2025, 14:30)
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Pesanan',
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
            return Center(
              child: Text(
                'Belum ada riwayat pesanan.',
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Tampilkan daftar pesanan
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final fullOrder = orders[index];
              final order = fullOrder.order;

              // Gunakan ExpansionTile untuk setiap pesanan
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  // Bagian Judul (Ringkasan Pesanan)
                  title: Text(
                    'Pesanan a.n. ${order.customerName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Meja: ${order.tableNumber} • ${dateFormatter.format(order.orderDate)}',
                  ),
                  trailing: Text(
                    currencyFormatter.format(order.totalAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  // Bagian Anak (Detail Item)
                  children: fullOrder.items.map((item) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(item.product.image),
                      ),
                      title: Text(item.product.title),
                      subtitle: Text(
                        '${item.orderItem.quantity} x ${currencyFormatter.format(item.orderItem.itemPrice)}',
                      ),
                      trailing: Text(
                        currencyFormatter.format(
                          item.orderItem.quantity * item.orderItem.itemPrice,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
