import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../orders/data/order_models.dart';

class JastipRepository {
  final Dio _dio = ApiClient.instance;

  Future<OrderModel> createCustomRequest({
    required String itemName,
    required int qty,
    required double estimatedPrice,
    String? addressId,
    String? itemNote,
    String? note,
  }) async {
    final res = await _dio.post('/orders/custom', data: {
      'itemName': itemName,
      'qty': qty,
      'estimatedPrice': estimatedPrice,
      'addressId': ?addressId,
      'itemNote': ?itemNote,
      'note': ?note,
      'deliveryFee': 8000,
    });
    return OrderModel.fromJson(res.data);
  }

  Future<List<OrderModel>> getCustomOrders() async {
    final res = await _dio.get('/orders');
    final all = (res.data as List).map((e) => OrderModel.fromJson(e)).toList();
    return all.where((o) => o.orderType == OrderType.customJastip).toList();
  }
}
