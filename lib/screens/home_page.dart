import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/') {
      return 0;
    }
    if (location == '/menu') {
      return 1;
    }
    if (location == '/favorite') {
      return 2;
    }
    if (location == '/profile') {
      return 3;
    }
    return 0; // Default
  }

  // Fungsi untuk pindah halaman saat item di-tap
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/menu');
        break;
      case 2:
        context.go('/favorite');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan halaman (child) yang dikirim oleh GoRouter
      body: widget.child,

      // BottomNavigationBar sekarang dikendalikan oleh GoRouter
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: const Color(0xFF44444E),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Menu"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ballot_rounded),
            label: "Riwayat",
          ),
        ],
      ),
    );
  }
}
