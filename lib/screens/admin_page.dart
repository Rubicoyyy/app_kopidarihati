import 'package:app_kopidarihati/widgets/universal_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../data/database/app_db.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelola Menu (Admin)',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      body: StreamBuilder<List<Product>>(
        stream: db.productDao.watchAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada produk.',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tekan tombol + untuk menambah.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50), 
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: UniversalImage(product.image, fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${product.category} • ${currencyFormatter.format(product.price)}',
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TOMBOL EDIT
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Pindah ke halaman form sambil membawa data produk ini
                          context.push('/admin/add', extra: product);
                        },
                      ),
                      // TOMBOL HAPUS (LAMA)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _showDeleteConfirmation(context, db, product);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/admin/add');
        },
        backgroundColor: const Color(0xFF6F4E37),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Tambah Produk",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AppDatabase db,
    Product product,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus "${product.title}"?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
            onPressed: () {
              // Panggil DAO untuk menghapus
              db.productDao.deleteProduct(product);
              Navigator.of(ctx).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produk berhasil dihapus.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
