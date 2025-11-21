// Lokasi: lib/screens/add_product_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart'
    show Value; // Kita hanya butuh Value jika perlu, tapi lewat companion aman

import '../data/database/app_db.dart'; // Ini sudah membawa semua kelas database

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input teks
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  // Default image path agar user tidak capek ngetik saat testing
  final _imageController = TextEditingController(
    text: 'assets/images/latte.jpg',
  );
  final _ratingController = TextEditingController(text: '4.5');

  // Kategori default
  String _selectedCategory = 'Coffee';
  final List<String> _categories = [
    'Coffee',
    'Tea',
    'Non Coffee',
    'Food and Snack',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final db = Provider.of<AppDatabase>(context, listen: false);

      // Masukkan data ke database
      // Perhatikan: Kita tidak perlu prefix 'drift.' karena sudah di-export oleh app_db
      db.productDao.insertProduct(
        ProductsCompanion.insert(
          title: _titleController.text,
          price: double.parse(_priceController.text),
          image: _imageController.text,
          rating: double.parse(_ratingController.text),
          category: _selectedCategory,
          // isFavorite otomatis false, jadi tidak perlu diisi
        ),
      );

      // Kembali ke halaman Admin
      context.pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Produk Baru',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Nama Produk
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.coffee),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Nama tidak boleh kosong';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 2. Harga
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga (Rp)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monetization_on),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Harga tidak boleh kosong';
                if (double.tryParse(value) == null)
                  return 'Masukkan angka yang valid';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 3. Kategori (Dropdown)
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // 4. Path Gambar
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Path Gambar (Assets)',
                hintText: 'assets/images/nama_file.jpg',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Path gambar tidak boleh kosong';
                return null;
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Tips: Pastikan file gambar sudah ada di folder assets/images/',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // 5. Rating
            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(
                labelText: 'Rating Awal (1.0 - 5.0)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.star),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'SIMPAN PRODUK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
