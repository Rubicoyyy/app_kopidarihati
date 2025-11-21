// Lokasi: lib/screens/profile_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart'; // Menggunakan LoginProvider

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil LoginProvider
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Tampilkan nama pengguna jika sudah login
          'Hi, ${loginProvider.currentUser?.username ?? 'Tamu'}',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Tombol Riwayat Pesanan (Selalu terlihat)
          Card(
            child: ListTile(
              leading: const Icon(Icons.history, color: Color(0xFF6F4E37)),
              title: const Text('Riwayat Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Lihat semua pesanan Anda sebelumnya'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/order-history');
              },
            ),
          ),
          
          // Tombol Admin (Hanya muncul jika peran-nya 'admin')
          if (loginProvider.isAdmin)
            Card(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: Colors.blueGrey),
                title: const Text('Kelola Menu (Admin)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Tambah, hapus, atau edit menu'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/admin');
                },
              ),
            ),

          // Tombol Logout
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                // Panggil fungsi logout
                context.read<LoginProvider>().logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}