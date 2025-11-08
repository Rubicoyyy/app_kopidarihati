// Lokasi: lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import model dari Drift
import '../data/database/app_db.dart';

class ProductCardWidget extends StatelessWidget {
  // Sekarang widget ini menerima Product dari Drift
  final Product product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
                // ===== PERBAIKAN DI SINI =====
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // Tanda '}' yang berlebih sudah dihapus dari sini
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
                // ===== AKHIR PERBAIKAN =====
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
                      product.title, // Mengakses properti dari model Drift
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF37353E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Rp ${product.price.toStringAsFixed(0)}", // Mengakses properti dari model Drift
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
                          product.rating
                              .toString(), // Mengakses properti dari model Drift
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF44444E),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
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
