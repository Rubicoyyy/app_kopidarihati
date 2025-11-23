import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/database/app_db.dart';
import '../widgets/universal_image.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return InkWell(
      onTap: () {
        context.push('/product-detail', extra: product);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex:
                  3, 
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: UniversalImage(
                  product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            Expanded(
              flex: 2, 
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, 
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, 
                        color: Color(0xFF37353E),
                      ),
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      "Rp ${product.price.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF44444E),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          padding: EdgeInsets
                              .zero, 
                          constraints:
                              const BoxConstraints(), 
                          icon: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product.isFavorite
                                ? Colors.red
                                : Colors.red.shade400,
                            size: 18, 
                          ),
                          onPressed: () {
                            db.productDao.toggleFavoriteStatus(product);
                          },
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
