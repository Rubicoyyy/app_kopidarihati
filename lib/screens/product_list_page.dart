import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/database/app_db.dart';
import '../widgets/category_tabs.dart';
import '../widgets/header.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late AppDatabase _db;
  late Stream<List<Product>> _productStream;
  String _selectedCategory = "All";
  final List<String> categories = const [
    "All",
    "Coffee",
    "Tea",
    "Non Coffee",
    "Food and Snack",
  ];
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _db = Provider.of<AppDatabase>(context, listen: false);
    _db.productDao.seedDatabase();
    _updateProductStream();
  }

  void _updateProductStream() {
    setState(() {
      _productStream = _db.productDao.watchProductsByCategory(
        _selectedCategory,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderWidget(),
          CategoryTabsWidget(
            categories: categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              _updateProductStream();
            },
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productStream,
              builder: (context, snapshot) {
                final products = snapshot.data ?? [];

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      "Menu untuk kategori '$_selectedCategory' belum tersedia.",
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCardWidget(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
