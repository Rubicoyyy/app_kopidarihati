// Lokasi: lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/database/app_db.dart';
import '../widgets/category_tabs.dart';
import '../widgets/header.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppDatabase _db;
  late Stream<List<Product>> _productStream;

  int _currentIndex = 0;
  String _selectedCategory = "All";
  final List<String> categories = const ["All", "Coffee", "Tea", "Non Coffee", "Food and Snack"];
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _db = Provider.of<AppDatabase>(context, listen: false);
    
    // Panggil seedDatabase dari DAO
    _db.productDao.seedDatabase(); 
    
    _updateProductStream();
  }

  void _updateProductStream() {
    setState(() {
      // Panggil fungsi watch dari DAO
      _productStream = _db.productDao.watchProductsByCategory(_selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
            ),
          ],
        ),
      ),
      // ===== KODE BOTTOMNAVIGATIONBAR YANG LENGKAP DIMASUKKAN DI SINI =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: const Color(0xFF44444E),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Menu"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
