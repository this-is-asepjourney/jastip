import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../orders/data/order_models.dart';

class MitraRepository {
  final Dio _dio = ApiClient.instance;

  Future<void> setOnlineStatus(bool isOnline) async {
    await _dio.put('/mitras/status', data: {'isOnline': isOnline});
  }

  Future<List<OrderModel>> getOrders() async {
    final res = await _dio.get('/mitras/orders');
    return (res.data as List).map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<OrderModel> acceptOrder(String orderId) async {
    final res = await _dio.post('/mitras/orders/$orderId/accept');
    return OrderModel.fromJson(res.data);
  }

  Future<OrderModel> updateOrderStatus(String orderId, String status) async {
    final res = await _dio.put('/mitras/orders/$orderId/status', data: {'status': status});
    return OrderModel.fromJson(res.data);
  }
}
