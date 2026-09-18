import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../stores/data/store_models.dart';
import '../data/products_repository.dart';

final _productsRepo = ProductsRepository();

final productsProvider = FutureProvider.family<List<ProductModel>, Map<String, String?>>((ref, params) async {
  return _productsRepo.getProducts(
    storeId: params['storeId'],
    categoryId: params['categoryId'],
    search: params['search'],
  );
});

final productDetailProvider = FutureProvider.family<ProductModel, String>((ref, productId) async {
  return _productsRepo.getProduct(productId);
});

final searchQueryProvider = StateProvider<String>((ref) => '');
