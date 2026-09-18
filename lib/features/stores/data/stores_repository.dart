import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../data/store_models.dart';

class StoresRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<StoreModel>> getStores() async {
    final res = await _dio.get('/stores');
    return (res.data as List).map((e) => StoreModel.fromJson(e)).toList();
  }

  Future<StoreModel> getStore(String id) async {
    final res = await _dio.get('/stores/$id');
    return StoreModel.fromJson(res.data);
  }

  Future<List<ProductModel>> getStoreProducts(String storeId) async {
    final res = await _dio.get('/products', queryParameters: {'storeId': storeId});
    return (res.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }
}
