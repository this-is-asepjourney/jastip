import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/domain/cart_provider.dart';
import '../../orders/data/order_models.dart';
import '../../orders/data/orders_repository.dart';


final _ordersRepo = OrdersRepository();

class CheckoutState {
  final bool isLoading;
  final String? error;
  final OrderModel? completedOrder;
  final String? selectedAddressId;
  final double deliveryFee;
  final String? customerNote;

  const CheckoutState({
    this.isLoading = false,
    this.error,
    this.completedOrder,
    this.selectedAddressId,
    this.deliveryFee = 8000,
    this.customerNote,
  });

  CheckoutState copyWith({
    bool? isLoading,
    String? error,
    OrderModel? completedOrder,
    String? selectedAddressId,
    double? deliveryFee,
    String? customerNote,
    bool clearError = false,
  }) => CheckoutState(
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
        completedOrder: completedOrder ?? this.completedOrder,
        selectedAddressId: selectedAddressId ?? this.selectedAddressId,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        customerNote: customerNote ?? this.customerNote,
      );
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier() : super(const CheckoutState());

  void setAddress(String addressId) {
    state = state.copyWith(selectedAddressId: addressId);
  }

  void setDeliveryFee(double fee) {
    state = state.copyWith(deliveryFee: fee);
  }

  void setNote(String note) {
    state = state.copyWith(customerNote: note);
  }

  Future<OrderModel?> placeOrder(CartState cart) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final items = cart.items.map((i) => {
        'productId': i.product.id,
        'productName': i.product.name,
        'qty': i.qty,
        'estimatedPrice': i.product.price,
        if (i.note != null) 'note': i.note,
      }).toList();

      final order = await _ordersRepo.createOrder(
        addressId: state.selectedAddressId,
        orderType: 'PRODUCT',
        items: items,
        deliveryFee: state.deliveryFee,
        customerNote: state.customerNote,
      );

      state = state.copyWith(isLoading: false, completedOrder: order);
      return order;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal membuat order: $e');
      return null;
    }
  }

  void reset() => state = const CheckoutState();
}

final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>(
  (_) => CheckoutNotifier(),
);
