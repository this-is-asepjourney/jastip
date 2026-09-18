import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../orders/data/order_models.dart';

class AddressesRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<AddressModel>> getAddresses() async {
    final res = await _dio.get('/addresses');
    return (res.data as List).map((e) => AddressModel.fromJson(e)).toList();
  }

  Future<AddressModel> createAddress(Map<String, dynamic> data) async {
    final res = await _dio.post('/addresses', data: data);
    return AddressModel.fromJson(res.data);
  }

  Future<AddressModel> updateAddress(String id, Map<String, dynamic> data) async {
    final res = await _dio.put('/addresses/$id', data: data);
    return AddressModel.fromJson(res.data);
  }

  Future<void> deleteAddress(String id) async {
    await _dio.delete('/addresses/$id');
  }
}
