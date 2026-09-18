import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../data/auth_models.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance;

  Future<Map<String, dynamic>> login(String phone, String password) async {
    final res = await _dio.post('/auth/login', data: {'phone': phone, 'password': password});
    final data = res.data as Map<String, dynamic>;
    await LocalStorage.saveAccessToken(data['access_token']);
    await LocalStorage.saveRefreshToken(data['refresh_token']);
    final user = UserModel.fromJson(data['user']);
    await LocalStorage.saveUserRole(user.role.name);
    await LocalStorage.saveUserId(user.id);
    return data;
  }

  Future<Map<String, dynamic>> register(String name, String phone, String password, [String? email]) async {
    final res = await _dio.post('/auth/register', data: {
      'name': name,
      'phone': phone,
      'password': password,
      'email': ?email,
    });
    final data = res.data as Map<String, dynamic>;
    await LocalStorage.saveAccessToken(data['access_token']);
    await LocalStorage.saveRefreshToken(data['refresh_token']);
    final user = UserModel.fromJson(data['user']);
    await LocalStorage.saveUserRole(user.role.name);
    await LocalStorage.saveUserId(user.id);
    return data;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {}
    await LocalStorage.clearAll();
  }

  Future<UserModel> getMe() async {
    final res = await _dio.get('/users/me');
    return UserModel.fromJson(res.data);
  }
}
