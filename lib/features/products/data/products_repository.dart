import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../stores/data/store_models.dart';

class ProductsRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<ProductModel>> getProducts({String? storeId, String? categoryId, String? search}) async {
    final res = await _dio.get('/products', queryParameters: {
      'storeId': ?storeId,
      'categoryId': ?categoryId,
      'search': ?search,
    });
    return (res.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel> getProduct(String id) async {
    final res = await _dio.get('/products/$id');
    return ProductModel.fromJson(res.data);
  }
}
