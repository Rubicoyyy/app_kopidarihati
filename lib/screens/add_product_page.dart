import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart' as drift;

import '../data/database/app_db.dart';
import '../widgets/universal_image.dart';

class AddProductPage extends StatefulWidget {
  final Product? productToEdit;
  const AddProductPage({super.key, this.productToEdit});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController(
    text: 'assets/images/latte.jpg',
  );
  final _ratingController = TextEditingController(text: '4.5');
  // ===== CONTROLLER BARU =====
  final _descController = TextEditingController();
  // ==========================

  String _selectedCategory = 'Coffee';
  final List<String> _categories = [
    'Coffee',
    'Tea',
    'Non Coffee',
    'Food and Snack',
  ];

  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final product = widget.productToEdit;
    if (product != null) {
      _titleController.text = product.title;
      _priceController.text = product.price.toStringAsFixed(0);
      _ratingController.text = product.rating.toString();
      _selectedCategory = product.category;
      _selectedImagePath = product.image;
      _imageController.text = product.image;
      _descController.text = product.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _ratingController.dispose();
    _descController.dispose(); // Dispose controller baru
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(pickedFile.path);
      final String localImagePath = '${directory.path}/$fileName';
      final File localImage = await File(pickedFile.path).copy(localImagePath);

      if (mounted) {
        setState(() {
          _selectedImagePath = localImage.path;
          _imageController.text = localImage.path;
        });
      }
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final imagePath = _selectedImagePath ?? _imageController.text;
      final db = Provider.of<AppDatabase>(context, listen: false);

      final title = _titleController.text;
      final price = double.parse(_priceController.text);
      final rating = double.parse(_ratingController.text);
      final description = _descController.text; // Ambil deskripsi

      if (widget.productToEdit != null) {
        // UPDATE
        final updatedProduct = Product(
          id: widget.productToEdit!.id,
          title: title,
          price: price,
          image: imagePath,
          rating: rating,
          category: _selectedCategory,
          isFavorite: widget.productToEdit!.isFavorite,
          description: description, // Simpan deskripsi
        );
        db.productDao.updateProduct(updatedProduct);
      } else {
        // INSERT
        db.productDao.insertProduct(
          ProductsCompanion.insert(
            title: title,
            price: price,
            image: imagePath,
            rating: rating,
            category: _selectedCategory,
            description: drift.Value(description), // Simpan deskripsi
          ),
        );
      }

      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Produk' : 'Tambah Produk Baru',
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
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child:
                    (_selectedImagePath != null ||
                        _imageController.text.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: UniversalImage(
                          _selectedImagePath ?? _imageController.text,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          Text("Tekan untuk pilih gambar"),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // ===== INPUT DESKRIPSI BARU =====
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Menu',
                border: OutlineInputBorder(),
                alignLabelWithHint: true, // Agar label di atas untuk multiline
              ),
              maxLines: 4, // Kotak lebih besar
              keyboardType: TextInputType.multiline,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // ===============================
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga (Rp)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(
                labelText: 'Rating',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isEditing ? 'UPDATE PRODUK' : 'SIMPAN PRODUK',
                style: const TextStyle(
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
