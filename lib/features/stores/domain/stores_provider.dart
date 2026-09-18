import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/store_models.dart';
import '../data/stores_repository.dart';

final _storesRepo = StoresRepository();

final storesProvider = FutureProvider<List<StoreModel>>((ref) async {
  return _storesRepo.getStores();
});

final storeDetailProvider = FutureProvider.family<StoreModel, String>((ref, storeId) async {
  return _storesRepo.getStore(storeId);
});

final storeProductsProvider = FutureProvider.family<List<ProductModel>, String>((ref, storeId) async {
  return _storesRepo.getStoreProducts(storeId);
});
