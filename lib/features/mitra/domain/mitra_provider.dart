import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mitra_repository.dart';
import '../../orders/data/order_models.dart';

final _mitraRepo = MitraRepository();

final mitraIsOnlineProvider = StateProvider<bool>((ref) => false);

final mitraOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  return _mitraRepo.getOrders();
});

class MitraActionNotifier extends StateNotifier<AsyncValue<void>> {
  MitraActionNotifier() : super(const AsyncValue.data(null));

  Future<void> toggleOnline(bool isOnline, WidgetRef ref) async {
    state = const AsyncValue.loading();
    try {
      await _mitraRepo.setOnlineStatus(isOnline);
      ref.read(mitraIsOnlineProvider.notifier).state = isOnline;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> acceptOrder(String orderId) async {
    state = const AsyncValue.loading();
    try {
      await _mitraRepo.acceptOrder(orderId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateStatus(String orderId, String status) async {
    state = const AsyncValue.loading();
    try {
      await _mitraRepo.updateOrderStatus(orderId, status);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final mitraActionProvider = StateNotifierProvider<MitraActionNotifier, AsyncValue<void>>(
  (_) => MitraActionNotifier(),
);
