import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../stores/data/store_models.dart';

// Cart item model
class CartItem {
  final String id;
  final ProductModel product;
  int qty;
  String? note;

  CartItem({
    required this.id,
    required this.product,
    required this.qty,
    this.note,
  });

  double get subtotal => product.price * qty;

  CartItem copyWith({int? qty, String? note}) => CartItem(
        id: id,
        product: product,
        qty: qty ?? this.qty,
        note: note ?? this.note,
      );
}

// Cart state
class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  double get serviceFee {
    const rate = 0.05;
    final fee = subtotal * rate;
    if (fee < 2000) return 2000;
    if (fee > 10000) return 10000;
    return fee;
  }

  double get deliveryFee => 8000; // Default zone B

  double get total => subtotal + serviceFee + deliveryFee;

  int get itemCount => items.fold(0, (sum, item) => sum + item.qty);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartItem>? items}) =>
      CartState(items: items ?? this.items);
}

// Cart notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(ProductModel product, {int qty = 1, String? note}) {
    final existing = state.items
        .where((i) => i.product.id == product.id)
        .firstOrNull;

    if (existing != null) {
      final updated = state.items.map((i) {
        if (i.product.id == product.id) {
          return i.copyWith(qty: i.qty + qty);
        }
        return i;
      }).toList();
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(
            id: 'ci_${DateTime.now().millisecondsSinceEpoch}',
            product: product,
            qty: qty,
            note: note,
          ),
        ],
      );
    }
  }

  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != itemId).toList(),
    );
  }

  void updateQty(String itemId, int qty) {
    if (qty <= 0) {
      removeItem(itemId);
      return;
    }
    state = state.copyWith(
      items: state.items.map((i) {
        if (i.id == itemId) return i.copyWith(qty: qty);
        return i;
      }).toList(),
    );
  }

  void clearCart() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (_) => CartNotifier(),
);
