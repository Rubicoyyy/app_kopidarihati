// Lokasi: lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'config/router.dart';
import 'data/database/app_db.dart';
import 'providers/cart_provider.dart';

// ===== 1. IMPORT PAKET INTIL =====
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // <-- 2. JADIKAN FUNGSI 'main' ASYNCHRONOUS
  // ===== 3. TAMBAHKAN DUA BARIS INI =====
  // Pastikan Flutter terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  // Muat data locale Indonesia (penting untuk format tanggal)
  await initializeDateFormatting('id_ID', null);
  // ===================================

  runApp(const KopiDariHatiApp());
}

class KopiDariHatiApp extends StatelessWidget {
  const KopiDariHatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          scaffoldBackgroundColor: const Color(0xFFF7F7F7),
          primaryColor: const Color(0xFF6F4E37),
          fontFamily: GoogleFonts.montserrat().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6F4E37)),
          useMaterial3: true,
        ),
      ),
    );
  }
}
