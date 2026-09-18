import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../data/order_models.dart';

class OrdersRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<OrderModel>> getOrders() async {
    final res = await _dio.get('/orders');
    return (res.data as List).map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<OrderModel> getOrder(String id) async {
    final res = await _dio.get('/orders/$id');
    return OrderModel.fromJson(res.data);
  }

  Future<OrderModel> createOrder({
    required String? addressId,
    required String orderType,
    required List<Map<String, dynamic>> items,
    required double deliveryFee,
    String? customerNote,
  }) async {
    final res = await _dio.post('/orders', data: {
      'addressId': addressId,
      'orderType': orderType,
      'items': items,
      'deliveryFee': deliveryFee,
      'customerNote': ?customerNote,
    });
    return OrderModel.fromJson(res.data);
  }

  Future<OrderModel> cancelOrder(String id) async {
    final res = await _dio.post('/orders/$id/cancel');
    return OrderModel.fromJson(res.data);
  }

  Future<OrderModel> createCustomJastip(Map<String, dynamic> data) async {
    final res = await _dio.post('/orders/custom', data: data);
    return OrderModel.fromJson(res.data);
  }
}
