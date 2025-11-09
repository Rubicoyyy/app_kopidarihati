// Lokasi: lib/config/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/database/app_db.dart';
import '../screens/cart_page.dart';
import '../screens/confirmation_page.dart';
import '../screens/detail_page.dart';
import '../screens/home_page.dart'; // Halaman Induk

// Halaman-halaman anak
import '../screens/dashboard_page.dart'; // <-- IMPORT HALAMAN BARU
import '../screens/product_list_page.dart';
import '../screens/favorite_page.dart';
import '../screens/order_history_page.dart';

// Hapus import menu_page.dart karena sudah tidak dipakai
// import '../screens/menu_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/', // Tetap '/' sebagai awal
  routes: [
    // ... (Rute /cart, /confirmation, /product-detail tidak berubah) ...
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(
      path: '/confirmation',
      builder: (context, state) => const ConfirmationPage(),
    ),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final product = state.extra as Product;
        return DetailPage(product: product);
      },
    ),

    // ShellRoute untuk navigasi bawah
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return HomePage(child: child);
      },
      routes: [
        // ===== PERUBAHAN DI SINI =====
        // Rute untuk tab Home (indeks 0)
        GoRoute(
          path: '/',
          // Sekarang mengarah ke DashboardPage
          builder: (context, state) => const DashboardPage(),
        ),

        // Rute untuk tab Menu (indeks 1)
        GoRoute(
          path: '/menu',
          // Sekarang mengarah ke ProductListPage (menu lengkap)
          builder: (context, state) => const ProductListPage(),
        ),
        // ============================

        // Rute untuk tab Favorite (indeks 2) - Tidak berubah
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoritePage(),
        ),

        // Rute untuk tab Profile (indeks 3) - Tidak berubah
        GoRoute(
          path: '/profile',
          builder: (context, state) => const OrderHistoryPage(),
        ),
      ],
    ),
  ],
);
