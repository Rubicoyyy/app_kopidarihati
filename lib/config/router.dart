// Lokasi: lib/config/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/database/app_db.dart';
import '../providers/login_provider.dart';

// Import semua halaman
import '../screens/login_page.dart';
import '../screens/cart_page.dart';
import '../screens/confirmation_page.dart';
import '../screens/detail_page.dart';
import '../screens/home_page.dart';
import '../screens/dashboard_page.dart';
import '../screens/product_list_page.dart';
import '../screens/favorite_page.dart';
import '../screens/order_history_page.dart';
import '../screens/add_product_page.dart';
import '../screens/profile_page.dart';
import '../screens/add_product_page.dart'; // <-- IMPORT HALAMAN BARU

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final LoginProvider loginProvider;
  late final GoRouter router;

  AppRouter(this.loginProvider) {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: loginProvider,

      redirect: (BuildContext context, GoRouterState state) {
        final bool isLoggedIn = loginProvider.isLoggedIn;
        final String location = state.uri.toString();

        // Jika BELUM login dan TIDAK di halaman login -> Lempar ke Login
        if (!isLoggedIn && location != '/login') {
          return '/login';
        }
        // Jika SUDAH login dan MASIH di halaman login -> Lempar ke Home
        if (isLoggedIn && location == '/login') {
          return '/';
        }
        return null;
      },

      routes: [
        // Rute Login
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),

        // Rute-rute Standalone (Tanpa Navigasi Bawah)
        GoRoute(path: '/cart', builder: (context, state) => CartPage()),
        GoRoute(
          path: '/confirmation',
          builder: (context, state) => ConfirmationPage(),
        ),
        GoRoute(
          path: '/product-detail',
          builder: (context, state) {
            final product = state.extra as Product;
            return DetailPage(product: product);
          },
        ),

        // ===== RUTE ADMIN =====
        GoRoute(path: '/admin', builder: (context, state) => AdminPage()),
        // Rute Tambah Produk Baru
        GoRoute(
          path: '/admin/add',
          builder: (context, state) => AddProductPage(),
        ),

        // ======================
        GoRoute(
          path: '/order-history',
          builder: (context, state) => OrderHistoryPage(),
        ),

        // Rute Shell (Dengan Navigasi Bawah)
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return HomePage(child: child);
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => DashboardPage()),
            GoRoute(
              path: '/menu',
              builder: (context, state) => ProductListPage(),
            ),
            GoRoute(
              path: '/favorite',
              builder: (context, state) => FavoritePage(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfilePage(),
            ),
          ],
        ),
      ],
    );
  }
}
