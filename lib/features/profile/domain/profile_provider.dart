import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../auth/data/auth_models.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Dio _dio = ApiClient.instance;

  ProfileNotifier() : super(const AsyncValue.data(null));

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final res = await _dio.get('/users/me');
      state = AsyncValue.data(UserModel.fromJson(res.data));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateProfile(String name, String? email) async {
    try {
      final res = await _dio.put('/users/me', data: {
        'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
      });
      state = AsyncValue.data(UserModel.fromJson(res.data));
      return true;
    } catch (_) {
      return false;
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<UserModel?>>(
  (_) => ProfileNotifier(),
);
