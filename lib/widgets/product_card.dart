// Lokasi: lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER

// Import model dari Drift
import '../data/database/app_db.dart';

class ProductCardWidget extends StatelessWidget {
  // Sekarang widget ini menerima Product dari Drift
  final Product product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // 2. AMBIL DATABASE DARI PROVIDER
    final db = Provider.of<AppDatabase>(context, listen: false);

    return InkWell(
      onTap: () {
        // Kirim objek 'product' dari Drift langsung
        context.push('/product-detail', extra: product);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF37353E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Rp ${product.price.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF44444E),
                          ),
                        ),
                        const Spacer(),

                        // ===== 3. PERUBAHAN UTAMA DI SINI =====
                        // Ganti Icon statis menjadi IconButton dinamis
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            // Tampilkan ikon berdasarkan status dari database
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            // Tampilkan warna berdasarkan status
                            color: product.isFavorite
                                ? Colors.red
                                : Colors.red.shade400,
                            size: 20,
                          ),
                          onPressed: () {
                            // Panggil fungsi DAO saat ikon ditekan
                            db.productDao.toggleFavoriteStatus(product);
                          },
                        ),
                        // ===== AKHIR PERUBAHAN =====
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
