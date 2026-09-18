import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/jastip_repository.dart';
import '../../orders/data/order_models.dart';

final _jastipRepo = JastipRepository();

class JastipFormState {
  final bool isLoading;
  final String? error;
  final bool success;

  const JastipFormState({this.isLoading = false, this.error, this.success = false});
}

class JastipNotifier extends StateNotifier<JastipFormState> {
  JastipNotifier() : super(const JastipFormState());

  Future<OrderModel?> submitRequest({
    required String itemName,
    required int qty,
    required double estimatedPrice,
    String? addressId,
    String? itemNote,
    String? note,
  }) async {
    state = const JastipFormState(isLoading: true);
    try {
      final order = await _jastipRepo.createCustomRequest(
        itemName: itemName,
        qty: qty,
        estimatedPrice: estimatedPrice,
        addressId: addressId,
        itemNote: itemNote,
        note: note,
      );
      state = const JastipFormState(success: true);
      return order;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Gagal mengirim request';
      state = JastipFormState(error: msg.toString());
      return null;
    } catch (_) {
      state = const JastipFormState(error: 'Terjadi kesalahan');
      return null;
    }
  }

  void reset() => state = const JastipFormState();
}

final jastipProvider = StateNotifierProvider<JastipNotifier, JastipFormState>(
  (_) => JastipNotifier(),
);
