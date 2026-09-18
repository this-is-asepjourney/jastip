import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/driver_models.dart';

// ─── Driver Online State ──────────────────────────────────────────────────────

final driverOnlineProvider = StateProvider<bool>((ref) => true);

// ─── Offers State ─────────────────────────────────────────────────────────────

class OffersNotifier extends StateNotifier<List<OfferModel>> {
  OffersNotifier() : super(MockOffers.all);

  /// Driver ambil order (first-come-first-served)
  void takeOffer(String offerId) {
    state = state.map((offer) {
      if (offer.id == offerId) {
        return OfferModel(
          id: offer.id,
          orderNumber: offer.orderNumber,
          customerName: offer.customerName,
          customerPhone: offer.customerPhone,
          storeName: offer.storeName,
          storeLocation: offer.storeLocation,
          deliveryAddress: offer.deliveryAddress,
          deliveryLocation: offer.deliveryLocation,
          items: offer.items,
          estimatedBudget: offer.estimatedBudget,
          status: OfferStatus.taken,
          createdAt: offer.createdAt,
        );
      }
      return offer;
    }).toList();
  }

  /// Refresh / reload penawaran
  void refresh() {
    state = MockOffers.all
        .where((o) => o.status == OfferStatus.pending)
        .toList();
  }
}

final offersProvider =
    StateNotifierProvider<OffersNotifier, List<OfferModel>>(
  (ref) => OffersNotifier(),
);

/// Hanya penawaran yang masih PENDING (belum diambil driver)
final pendingOffersProvider = Provider<List<OfferModel>>((ref) {
  return ref.watch(offersProvider)
      .where((o) => o.status == OfferStatus.pending)
      .toList();
});

/// Penawaran yang sudah diambil driver ini
final myActiveOffersProvider = Provider<List<OfferModel>>((ref) {
  return ref.watch(offersProvider)
      .where((o) => o.status == OfferStatus.taken ||
                    o.status == OfferStatus.shopping ||
                    o.status == OfferStatus.delivering)
      .toList();
});
