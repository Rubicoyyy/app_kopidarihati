// Lokasi: lib/models/full_order_details.dart

// PERBAIKAN: Path import ini sudah benar
import '../data/database/app_db.dart'; 

// Model ini membungkus satu pesanan dan daftar item di dalamnya
class FullOrderDetails {
  final Order order;
  final List<FullOrderItem> items;

  FullOrderDetails({required this.order, required this.items});
}

// Model ini membungkus satu item pesanan DAN detail produknya
class FullOrderItem {
  final OrderItem orderItem;
  final Product product; // Detail produk (nama, gambar, dll)

  FullOrderItem({required this.orderItem, required this.product});
}