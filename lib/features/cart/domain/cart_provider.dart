import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../stores/data/store_models.dart';

class CartItem {
  final ProductModel product;
  final int qty;
  final String? note;

  const CartItem({required this.product, this.qty = 1, this.note});

  CartItem copyWith({int? qty, String? note}) =>
      CartItem(product: product, qty: qty ?? this.qty, note: note ?? this.note);

  double get subtotal => product.price * qty;
  String get id => product.id;
}

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get subtotal => items.fold(0, (sum, e) => sum + e.subtotal);
  int get totalQty => items.fold(0, (sum, e) => sum + e.qty);
  int get itemCount => totalQty;
  bool get isEmpty => items.isEmpty;

  double get serviceFee => isEmpty ? 0 : 5000;
  double get deliveryFee => isEmpty ? 0 : 8000;
  double get total => subtotal + serviceFee + deliveryFee;

  CartState copyWith({List<CartItem>? items}) => CartState(items: items ?? this.items);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(ProductModel product, {int qty = 1, String? note}) {
    final existingIndex = state.items.indexWhere((i) => i.product.id == product.id);
    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state.items);
      updated[existingIndex] = updated[existingIndex].copyWith(
        qty: updated[existingIndex].qty + qty,
      );
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(items: [...state.items, CartItem(product: product, qty: qty, note: note)]);
    }
  }

  void removeItem(String productId) {
    state = state.copyWith(items: state.items.where((i) => i.product.id != productId).toList());
  }

  void updateQty(String productId, int qty) {
    if (qty <= 0) {
      removeItem(productId);
      return;
    }
    final updated = state.items.map((i) => i.product.id == productId ? i.copyWith(qty: qty) : i).toList();
    state = state.copyWith(items: updated);
  }

  void clear() => state = const CartState();
  void clearCart() => clear();
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (_) => CartNotifier(),
);
