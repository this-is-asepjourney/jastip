import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/driver_models.dart';
import '../data/driver_repository.dart';

// ─── Singleton repository ─────────────────────────────────────────────────────
final _repo = DriverRepository();

// ─── Driver Online State ──────────────────────────────────────────────────────
final driverOnlineProvider = StateProvider<bool>((ref) => true);

// ─── Offers Async State ───────────────────────────────────────────────────────

enum OfferLoadStatus { idle, loading, loaded, error }

class OffersState {
  final List<OfferModel> offers;
  final OfferLoadStatus status;
  final String? errorMessage;

  const OffersState({
    this.offers = const [],
    this.status = OfferLoadStatus.idle,
    this.errorMessage,
  });

  OffersState copyWith({
    List<OfferModel>? offers,
    OfferLoadStatus? status,
    String? errorMessage,
  }) =>
      OffersState(
        offers: offers ?? this.offers,
        status: status ?? this.status,
        errorMessage: errorMessage,
      );
}

class OffersNotifier extends StateNotifier<OffersState> {
  OffersNotifier() : super(const OffersState()) {
    loadOffers();
  }

  /// Load dari backend (dengan fallback ke mock data)
  Future<void> loadOffers() async {
    state = state.copyWith(status: OfferLoadStatus.loading);
    try {
      final offers = await _repo.fetchOffers();
      state = state.copyWith(
        offers: offers,
        status: OfferLoadStatus.loaded,
      );
    } catch (e) {
      state = state.copyWith(
        status: OfferLoadStatus.error,
        errorMessage: e.toString(),
        // Fallback ke mock data
        offers: MockOffers.all,
      );
    }
  }

  /// Driver ambil order — kirim ke backend
  Future<void> takeOffer(String offerId) async {
    // Optimistic update: tandai offer sebagai "taken" di UI
    state = state.copyWith(
      offers: state.offers.map((o) {
        if (o.id == offerId) return _withStatus(o, OfferStatus.taken);
        return o;
      }).toList(),
    );

    try {
      await _repo.takeOffer(offerId);
    } catch (e) {
      // Rollback jika gagal
      state = state.copyWith(
        offers: state.offers.map((o) {
          if (o.id == offerId) return _withStatus(o, OfferStatus.pending);
          return o;
        }).toList(),
      );
      rethrow;
    }
  }

  OfferModel _withStatus(OfferModel o, OfferStatus status) => OfferModel(
        id: o.id,
        orderNumber: o.orderNumber,
        customerName: o.customerName,
        customerPhone: o.customerPhone,
        storeName: o.storeName,
        storeLocation: o.storeLocation,
        deliveryAddress: o.deliveryAddress,
        deliveryLocation: o.deliveryLocation,
        items: o.items,
        estimatedBudget: o.estimatedBudget,
        status: status,
        createdAt: o.createdAt,
      );
}

final offersProvider =
    StateNotifierProvider<OffersNotifier, OffersState>(
  (ref) => OffersNotifier(),
);

/// Hanya penawaran PENDING (yang belum diambil driver)
final pendingOffersProvider = Provider<List<OfferModel>>((ref) {
  return ref
      .watch(offersProvider)
      .offers
      .where((o) => o.status == OfferStatus.pending)
      .toList();
});

/// Penawaran yang sudah diambil oleh driver ini
final myActiveOffersProvider = Provider<List<OfferModel>>((ref) {
  return ref
      .watch(offersProvider)
      .offers
      .where((o) =>
          o.status == OfferStatus.taken ||
          o.status == OfferStatus.shopping ||
          o.status == OfferStatus.delivering)
      .toList();
});
