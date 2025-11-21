import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/router.dart';
import 'data/database/app_db.dart';
import 'providers/cart_provider.dart';
import 'providers/login_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  final db = AppDatabase();
  final loginProvider = LoginProvider(db);

  runApp(KopiDariHatiApp(db: db, loginProvider: loginProvider));
}

class KopiDariHatiApp extends StatelessWidget {
  final AppDatabase db;
  final LoginProvider loginProvider;

  KopiDariHatiApp({super.key, required this.db, required this.loginProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider<LoginProvider>.value(value: loginProvider),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter(loginProvider).router,
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
