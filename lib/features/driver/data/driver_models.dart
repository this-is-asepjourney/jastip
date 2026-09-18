import 'package:latlong2/latlong.dart';

/// Status sebuah penawaran customer
enum OfferStatus {
  pending,
  taken,
  shopping,
  delivering,
  done,
  cancelled,
}

extension OfferStatusLabel on OfferStatus {
  String get label {
    switch (this) {
      case OfferStatus.pending:    return 'Menunggu Driver';
      case OfferStatus.taken:      return 'Driver Ditemukan';
      case OfferStatus.shopping:   return 'Sedang Belanja';
      case OfferStatus.delivering: return 'Dalam Pengiriman';
      case OfferStatus.done:       return 'Selesai';
      case OfferStatus.cancelled:  return 'Dibatalkan';
    }
  }
}

class OfferItem {
  final String name;
  final String? note;
  final int qty;

  const OfferItem({required this.name, this.note, required this.qty});
}

/// Model penawaran (request) dari customer yang terlihat oleh driver di peta
class OfferModel {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;

  /// Nama toko / tempat belanja yang diminta customer
  final String storeName;

  /// Koordinat toko — COMING SOON: diisi dari koordinat nyata customer
  final LatLng storeLocation;

  /// Alamat antar / tujuan pengiriman
  final String deliveryAddress;

  /// Koordinat tujuan pengiriman — COMING SOON: diisi dari koordinat nyata customer
  final LatLng deliveryLocation;

  final List<OfferItem> items;

  /// Estimasi budget — perhitungan akan dikembangkan lebih lanjut
  final double? estimatedBudget;

  final OfferStatus status;
  final DateTime createdAt;

  const OfferModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.storeName,
    required this.storeLocation,
    required this.deliveryAddress,
    required this.deliveryLocation,
    required this.items,
    this.estimatedBudget,
    required this.status,
    required this.createdAt,
  });

  String get itemSummary {
    if (items.isEmpty) return '-';
    if (items.length == 1) return '${items.first.name} x${items.first.qty}';
    return '${items.first.name} x${items.first.qty}  +${items.length - 1} lainnya';
  }
}

// ─── Mock Data (sekitar Wirosari, Grobogan) ─────────────────────────────────
// Pusat Wirosari: lat -7.0626, lng 110.9149
class MockOffers {
  static final List<OfferModel> all = [
    OfferModel(
      id: 'offer-1',
      orderNumber: 'JW-20260918-1001',
      customerName: 'Budi Santoso',
      customerPhone: '0812-3456-7890',
      storeName: 'Indomaret Wirosari',
      storeLocation: const LatLng(-7.0610, 110.9135),
      deliveryAddress: 'Jl. Pemuda No. 5, Wirosari',
      deliveryLocation: const LatLng(-7.0648, 110.9172),
      items: const [
        OfferItem(name: 'Minyak Bimoli 2L', qty: 2),
        OfferItem(name: 'Gula Pasir 1kg', qty: 1, note: 'Merek apa saja'),
      ],
      estimatedBudget: 85000,
      status: OfferStatus.pending,
      createdAt: DateTime.now(),
    ),
    OfferModel(
      id: 'offer-2',
      orderNumber: 'JW-20260918-1002',
      customerName: 'Siti Rahayu',
      customerPhone: '0857-9876-5432',
      storeName: 'Alfamart Purwodadi',
      storeLocation: const LatLng(-7.0590, 110.9115),
      deliveryAddress: 'Perum Griya Asri Blok B/3, Wirosari',
      deliveryLocation: const LatLng(-7.0660, 110.9200),
      items: const [
        OfferItem(name: 'Susu Formula SGM Step 2', qty: 1),
        OfferItem(name: 'Pampers M 40pcs', qty: 1),
      ],
      estimatedBudget: 150000,
      status: OfferStatus.pending,
      createdAt: DateTime.now(),
    ),
    OfferModel(
      id: 'offer-3',
      orderNumber: 'JW-20260918-1003',
      customerName: 'Ahmad Fauzi',
      customerPhone: '0821-1122-3344',
      storeName: 'Apotek Sehat Wirosari',
      storeLocation: const LatLng(-7.0635, 110.9165),
      deliveryAddress: 'Jl. Diponegoro No. 12, Wirosari',
      deliveryLocation: const LatLng(-7.0672, 110.9130),
      items: const [
        OfferItem(name: 'Paracetamol 500mg', qty: 2, note: 'Strip'),
        OfferItem(name: 'Betadine 30ml', qty: 1),
        OfferItem(name: 'Plester', qty: 1),
      ],
      estimatedBudget: 45000,
      status: OfferStatus.pending,
      createdAt: DateTime.now(),
    ),
    OfferModel(
      id: 'offer-4',
      orderNumber: 'JW-20260918-1004',
      customerName: 'Dewi Lestari',
      customerPhone: '0878-5544-3322',
      storeName: 'Pasar Wirosari',
      storeLocation: const LatLng(-7.0600, 110.9155),
      deliveryAddress: 'Jl. Merdeka No. 20, Wirosari',
      deliveryLocation: const LatLng(-7.0685, 110.9145),
      items: const [
        OfferItem(name: 'Sayur Bayam', qty: 2, note: 'Seikat'),
        OfferItem(name: 'Tempe', qty: 3, note: 'Papan'),
        OfferItem(name: 'Cabai Merah', qty: 1, note: '1/4 kg'),
        OfferItem(name: 'Bawang Putih', qty: 1, note: '1/4 kg'),
      ],
      estimatedBudget: 35000,
      status: OfferStatus.pending,
      createdAt: DateTime.now(),
    ),
    OfferModel(
      id: 'offer-5',
      orderNumber: 'JW-20260918-1005',
      customerName: 'Rina Wulandari',
      customerPhone: '0813-7788-9900',
      storeName: 'Toko Bangunan Jaya',
      storeLocation: const LatLng(-7.0575, 110.9180),
      deliveryAddress: 'Jl. Veteran No. 8, Wirosari',
      deliveryLocation: const LatLng(-7.0620, 110.9210),
      items: const [
        OfferItem(name: 'Cat Tembok Putih 5kg', qty: 1, note: 'Merek Catylac'),
        OfferItem(name: 'Kuas Cat 3 inch', qty: 2),
      ],
      estimatedBudget: 120000,
      status: OfferStatus.pending,
      createdAt: DateTime.now(),
    ),
  ];
}
