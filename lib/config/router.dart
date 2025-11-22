import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/database/app_db.dart';
import '../providers/login_provider.dart';
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
import '../screens/admin_page.dart';
import '../screens/search_page.dart';
import '../screens/register_page.dart';
import '../screens/edit_profile_page.dart';
import '../screens/admin_order_page.dart';

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

        final bool isLoggingIn = location == '/login';
        final bool isRegistering = location == '/register';

        if (!isLoggedIn && !isLoggingIn && !isRegistering) {
          return '/login';
        }

        if (isLoggedIn && (isLoggingIn || isRegistering)) {
          return '/';
        }

        return null;
      },

      routes: [
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),

        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),

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

        GoRoute(path: '/admin', builder: (context, state) => AdminPage()),
        GoRoute(
          path: '/admin/add',
          builder: (context, state) {
            final productToEdit = state.extra as Product?;
            return AddProductPage(productToEdit: productToEdit);
          },
        ),

        GoRoute(
          path: '/admin/orders',
          builder: (context, state) => const AdminOrderPage(),
        ),

        GoRoute(
          path: '/profile/edit',
          builder: (context, state) => const EditProfilePage(),
        ),

        GoRoute(
          path: '/order-history',
          builder: (context, state) => OrderHistoryPage(),
        ),

        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchPage(),
        ),

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
