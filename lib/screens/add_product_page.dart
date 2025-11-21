// Lokasi: lib/screens/add_product_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
//import 'package:drift/drift.dart' as drift; // Kita butuh alias untuk 'Value' jika pakai Companion

import '../data/database/app_db.dart';

class AddProductPage extends StatefulWidget {
  // Terima parameter opsional: produk yang ingin diedit
  final Product? productToEdit;

  const AddProductPage({super.key, this.productToEdit});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;
  late TextEditingController _ratingController;
  late String _selectedCategory;

  // List kategori
  final List<String> _categories = ['Coffee', 'Tea', 'Non Coffee', 'Food and Snack'];

  @override
  void initState() {
    super.initState();
    // Cek apakah mode Edit atau Tambah Baru
    final product = widget.productToEdit;

    if (product != null) {
      // === MODE EDIT: Isi form dengan data lama ===
      _titleController = TextEditingController(text: product.title);
      _priceController = TextEditingController(text: product.price.toStringAsFixed(0)); // Hapus desimal
      _imageController = TextEditingController(text: product.image);
      _ratingController = TextEditingController(text: product.rating.toString());
      _selectedCategory = product.category;
    } else {
      // === MODE TAMBAH BARU: Isi default ===
      _titleController = TextEditingController();
      _priceController = TextEditingController();
      _imageController = TextEditingController(text: 'assets/images/latte.jpg');
      _ratingController = TextEditingController(text: '4.5');
      _selectedCategory = 'Coffee';
    }
  }

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
      final title = _titleController.text;
      final price = double.parse(_priceController.text);
      final image = _imageController.text;
      final rating = double.parse(_ratingController.text);

      if (widget.productToEdit != null) {
        // === LOGIKA UPDATE ===
        // Kita buat objek Product baru dengan ID yang sama
        final updatedProduct = Product(
          id: widget.productToEdit!.id, // PENTING: ID tidak boleh berubah
          title: title,
          price: price,
          image: image,
          rating: rating,
          category: _selectedCategory,
          isFavorite: widget.productToEdit!.isFavorite, // Pertahankan status favorit
        );

        db.productDao.updateProduct(updatedProduct);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil diperbarui!'), backgroundColor: Colors.blue),
        );
      } else {
        // === LOGIKA INSERT ===
        db.productDao.insertProduct(
          ProductsCompanion.insert(
            title: title,
            price: price,
            image: image,
            rating: rating,
            category: _selectedCategory,
          ),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan!'), backgroundColor: Colors.green),
        );
      }

      context.pop(); // Kembali ke halaman Admin
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Produk' : 'Tambah Produk Baru', 
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nama Produk', border: OutlineInputBorder(), prefixIcon: Icon(Icons.coffee)),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Harga (Rp)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.monetization_on)),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Path Gambar', hintText: 'assets/images/...', border: OutlineInputBorder(), prefixIcon: Icon(Icons.image)),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Rating', border: OutlineInputBorder(), prefixIcon: Icon(Icons.star)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEditing ? Colors.blue : const Color(0xFF6F4E37),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isEditing ? 'UPDATE PRODUK' : 'SIMPAN PRODUK',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}