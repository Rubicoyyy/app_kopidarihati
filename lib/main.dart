// Lokasi: lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'config/router.dart';
import 'data/database/app_db.dart'; // Import AppDatabase
import 'providers/cart_provider.dart';

void main() {
  runApp(const KopiDariHatiApp());
}

class KopiDariHatiApp extends StatelessWidget {
  const KopiDariHatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan MultiProvider untuk menyediakan lebih dari satu provider
    return MultiProvider(
      providers: [
        // Sediakan AppDatabase secara global
        Provider<AppDatabase>(
          create: (context) => AppDatabase(),
          dispose: (context, db) => db.close(),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Kopi Dari Hati',
        theme: ThemeData(
          // ... (Tidak ada perubahan di sini)
        ),
      ),
    );
  }
}
