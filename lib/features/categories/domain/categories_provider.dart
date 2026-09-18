import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/category_models.dart';
import '../data/categories_repository.dart';

final _categoriesRepo = CategoriesRepository();

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return _categoriesRepo.getCategories();
});
