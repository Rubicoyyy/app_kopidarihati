// Lokasi: lib/screens/search_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../data/database/app_db.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controller untuk menangani teks yang diketik
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        // Kolom Input Pencarian
        title: TextField(
          controller: _searchController,
          autofocus: true, // Keyboard langsung muncul
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Cari kopi atau makanan...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            // Update pencarian setiap kali user mengetik
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          // Tombol hapus teks
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
        ],
      ),
      body: _searchQuery.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Ketik nama menu untuk mencari.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : StreamBuilder<List<Product>>(
              // Memanggil fungsi searchProducts dari DAO
              stream: db.productDao.searchProducts(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final results = snapshot.data ?? [];

                if (results.isEmpty) {
                  return Center(
                    child: Text("Tidak ditemukan menu '$_searchQuery'"),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final product = results[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(product.image),
                      ),
                      title: Text(
                        product.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(currencyFormatter.format(product.price)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Buka detail produk
                        context.push('/product-detail', extra: product);
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
