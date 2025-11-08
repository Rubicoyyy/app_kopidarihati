// Lokasi: lib/config/router.dart

import 'package:go_router/go_router.dart';

// HANYA impor Product dari Drift
import '../data/database/app_db.dart';

import '../screens/cart_page.dart';
import '../screens/confirmation_page.dart';
import '../screens/detail_page.dart';
import '../screens/home_page.dart';

// Buat instance GoRouter
final GoRouter router = GoRouter(
  // initialLocation akan menentukan rute awal saat aplikasi dibuka
  initialLocation: '/',

  // routes adalah daftar semua rute/halaman yang ada di aplikasi
  routes: [
    // Rute untuk Halaman Utama
    GoRoute(path: '/', builder: (context, state) => const HomePage()),

    // Rute untuk Halaman Detail Produk
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        // Menerima objek Product yang dikirim melalui parameter 'extra'
        final product = state.extra as Product;
        return DetailPage(product: product);
      },
    ),

    // Rute untuk Halaman Keranjang
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),

    // Rute untuk Halaman Konfirmasi
    GoRoute(
      path: '/confirmation',
      builder: (context, state) => const ConfirmationPage(),
    ),
  ],
);
