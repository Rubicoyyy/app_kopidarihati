import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi, ${loginProvider.currentUser?.username ?? 'Tamu'}',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ===== 1. AREA CUSTOMER (Semua bisa lihat) =====
          
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Ubah username & password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/profile/edit');
              },
            ),
          ),
          
          // Tombol Riwayat Pesanan
          Card(
            child: ListTile(
              leading: const Icon(Icons.history, color: Color(0xFF6F4E37)),
              title: const Text('Riwayat Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Lihat status pesanan Anda'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/order-history');
              },
            ),
          ),
          
          const SizedBox(height: 12),

          // ===== 2. AREA KHUSUS ADMIN (Hanya Admin yang bisa lihat) =====
          if (loginProvider.isAdmin) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Area Admin",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            
            // Tombol Kelola Menu
            Card(
              color: Colors.orange.shade50, 
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: Colors.blueGrey),
                title: const Text('Kelola Menu', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Tambah/Hapus Produk'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/admin');
                },
              ),
            ),

            // Tombol Dapur (Pesanan Masuk)
            Card(
              color: Colors.orange.shade50, 
              child: ListTile(
                leading: const Icon(Icons.restaurant_menu, color: Colors.orange),
                title: const Text('Dapur (Pesanan)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Proses pesanan masuk'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/admin/orders');
                },
              ),
            ),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          
          // Tombol Logout
          Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                context.read<LoginProvider>().logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}