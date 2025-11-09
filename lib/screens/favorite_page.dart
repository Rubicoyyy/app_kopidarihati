// Lokasi: lib/screens/favorite_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/database/app_db.dart';
import '../widgets/product_card.dart'; // Kita gunakan ulang widget kartu

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Favorit Anda'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<List<Product>>(
        // Buat stream baru di DAO (akan kita tambahkan)
        stream: db.productDao.watchFavoriteProducts(),
        builder: (context, snapshot) {
          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(
              child: Text('Anda belum punya produk favorit.'),
            );
          }

          // Tampilkan sebagai Grid, sama seperti halaman utama
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCardWidget(product: product);
            },
          );
        },
      ),
    );
  }
}
