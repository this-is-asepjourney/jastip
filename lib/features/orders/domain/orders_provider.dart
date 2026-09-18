import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/order_models.dart';
import '../data/orders_repository.dart';

final _ordersRepo = OrdersRepository();

// List orders
final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  return _ordersRepo.getOrders();
});

// Single order
final orderDetailProvider = FutureProvider.family<OrderModel, String>((ref, id) async {
  return _ordersRepo.getOrder(id);
});

// Create order state
class CreateOrderState {
  final bool isLoading;
  final String? error;
  final OrderModel? createdOrder;

  const CreateOrderState({this.isLoading = false, this.error, this.createdOrder});
}

class CreateOrderNotifier extends StateNotifier<CreateOrderState> {
  CreateOrderNotifier() : super(const CreateOrderState());

  Future<OrderModel?> createOrder({
    required String? addressId,
    required List<Map<String, dynamic>> items,
    required double deliveryFee,
    String? customerNote,
  }) async {
    state = const CreateOrderState(isLoading: true);
    try {
      final order = await _ordersRepo.createOrder(
        addressId: addressId,
        orderType: 'PRODUCT',
        items: items,
        deliveryFee: deliveryFee,
        customerNote: customerNote,
      );
      state = CreateOrderState(createdOrder: order);
      return order;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Gagal membuat order';
      state = CreateOrderState(error: msg.toString());
      return null;
    } catch (_) {
      state = const CreateOrderState(error: 'Terjadi kesalahan');
      return null;
    }
  }

  Future<OrderModel?> cancelOrder(String id) async {
    state = const CreateOrderState(isLoading: true);
    try {
      final order = await _ordersRepo.cancelOrder(id);
      state = const CreateOrderState();
      return order;
    } catch (_) {
      state = const CreateOrderState(error: 'Gagal membatalkan order');
      return null;
    }
  }
}

final createOrderProvider = StateNotifierProvider<CreateOrderNotifier, CreateOrderState>(
  (_) => CreateOrderNotifier(),
);
