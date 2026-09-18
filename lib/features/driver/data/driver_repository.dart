import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../data/driver_models.dart';
import 'package:latlong2/latlong.dart';

/// Repository untuk komunikasi dengan backend (endpoint offers/driver)
class DriverRepository {
  final Dio _dio = ApiClient.instance;

  // ── Driver: ambil semua penawaran PENDING dari backend ─────────────────────
  Future<List<OfferModel>> fetchOffers() async {
    try {
      final res = await _dio.get('/orders/offers');
      final list = res.data as List<dynamic>;
      return list.map((json) => _mapToOfferModel(json)).toList();
    } catch (_) {
      // Fallback ke mock data jika backend tidak tersedia
      return MockOffers.all;
    }
  }

  // ── Driver: ambil order (PATCH /orders/:id/take) ───────────────────────────
  Future<bool> takeOffer(String orderId) async {
    try {
      await _dio.patch('/orders/$orderId/take');
      return true;
    } catch (e) {
      if (e is DioException) {
        final msg = e.response?.data?['message'] ?? 'Gagal mengambil order';
        throw Exception(msg);
      }
      rethrow;
    }
  }

  // ── Customer: kirim penawaran (POST /orders/custom) ────────────────────────
  Future<Map<String, dynamic>> createOffer({
    required String itemName,
    required String storeName,
    required int qty,
    String? note,
    String? addressId,
    required LatLng storeLocation,
    required LatLng deliveryLocation,
  }) async {
    final res = await _dio.post('/orders/custom', data: {
      'itemName': itemName,
      'storeName': storeName,
      'qty': qty,
      'note': note,
      'estimatedPrice': 0,   // harga dikonfirmasi driver setelah belanja
      'deliveryFee': 8000,
      'addressId': addressId,
      'itemNote': note,
      'storeLat': storeLocation.latitude,
      'storeLng': storeLocation.longitude,
      'deliveryLat': deliveryLocation.latitude,
      'deliveryLng': deliveryLocation.longitude,
    });
    return res.data as Map<String, dynamic>;
  }

  // ── Mapper: backend JSON → OfferModel ──────────────────────────────────────
  OfferModel _mapToOfferModel(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((item) => OfferItem(
              name: item['productName'] ?? '',
              qty: (item['qty'] as num?)?.toInt() ?? 1,
              note: item['note'],
            ))
        .toList();

    final address = json['address'];
    final delivery = json['delivery'];

    // Koordinat pengantaran
    final deliveryLat = (delivery?['destinationLat'] as num?)?.toDouble() ?? 
                        (address?['latitude'] as num?)?.toDouble() ?? -7.0648;
    final deliveryLng = (delivery?['destinationLng'] as num?)?.toDouble() ?? 
                        (address?['longitude'] as num?)?.toDouble() ?? 110.9172;

    // Lokasi toko (dari delivery.pickupLat/Lng jika ada)
    final storeLat = (delivery?['pickupLat'] as num?)?.toDouble() ?? -7.0626;
    final storeLng = (delivery?['pickupLng'] as num?)?.toDouble() ?? 110.9149;

    return OfferModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      customerName: json['customer']?['name'] ?? 'Customer',
      customerPhone: json['customer']?['phone'] ?? '',
      storeName: _extractStoreName(json),
      storeLocation: LatLng(storeLat, storeLng),
      deliveryAddress: address?['address'] ?? 'Wirosari, Grobogan',
      deliveryLocation: LatLng(deliveryLat, deliveryLng),
      items: items,
      estimatedBudget: (json['total'] as num?)?.toDouble(),
      status: OfferStatus.pending,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  String _extractStoreName(Map<String, dynamic> json) {
    // storeName dari customerNote atau dari nama item
    final note = json['customerNote'] as String?;
    if (note != null && note.isNotEmpty) return note;
    final items = json['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return 'Toko';
    return (items.first['note'] as String?) ?? 'Toko';
  }
}
