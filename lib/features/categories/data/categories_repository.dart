import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../data/category_models.dart';

class CategoriesRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<CategoryModel>> getCategories() async {
    final res = await _dio.get('/categories');
    return (res.data as List).map((e) => CategoryModel.fromJson(e)).toList();
  }
}
