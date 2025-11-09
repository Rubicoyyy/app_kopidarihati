// Lokasi: lib/screens/detail_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/database/app_db.dart';
import '../providers/cart_provider.dart';

// 1. Ubah menjadi StatefulWidget
class DetailPage extends StatefulWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // 2. Buat state lokal untuk melacak status favorit
  // Kita inisialisasi dengan nilai dari produk
  late bool isFavorite;
  late AppDatabase db;

  @override
  void initState() {
    super.initState();
    // 3. Ambil nilai awal dari 'widget.product'
    isFavorite = widget.product.isFavorite;
    db = Provider.of<AppDatabase>(context, listen: false);
  }

  // 4. Buat fungsi untuk menangani toggle favorit
  void _toggleFavorite() {
    // Update database
    db.productDao.toggleFavoriteStatus(widget.product);

    // Update state lokal agar UI langsung berubah
    setState(() {
      isFavorite = !isFavorite;
    });

    // Tampilkan notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? '${widget.product.title} ditambahkan ke favorit!'
              : '${widget.product.title} dihapus dari favorit.',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: isFavorite ? Colors.pink : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // 5. Kita buat AppBar kustom agar bisa menaruh ikon di atas gambar
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            // Tombol Kembali
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            // Tombol Favorit
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: _toggleFavorite, // Panggil fungsi toggle
                  ),
                ),
              ),
            ],
            // Gambar Produk
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(widget.product.image, fit: BoxFit.cover),
            ),
          ),

          // 6. Konten Halaman (Bagian Detail Teks)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title, // Gunakan 'widget.product'
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            widget.product.rating.toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Deskripsi",
                    // ... (Style Teks)
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Perpaduan sempurna...",
                    // ... (Style Teks)
                  ),
                  const SizedBox(height: 24), // Beri jarak sebelum harga
                  // Bagian Harga dan Tombol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Harga"),
                          Text(
                            currencyFormatter.format(widget.product.price),
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          final cart = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );
                          cart.addItem(widget.product);
                          // ... (Logika SnackBar 'Add to Cart')
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          // ... (Style Tombol)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
