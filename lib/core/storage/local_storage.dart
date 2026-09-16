import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) throw Exception('LocalStorage not initialized');
    return _prefs!;
  }

  // Token
  static Future<void> saveAccessToken(String token) async =>
      _instance.setString(AppConfig.keyAccessToken, token);

  static String? getAccessToken() =>
      _instance.getString(AppConfig.keyAccessToken);

  static Future<void> saveRefreshToken(String token) async =>
      _instance.setString(AppConfig.keyRefreshToken, token);

  static String? getRefreshToken() =>
      _instance.getString(AppConfig.keyRefreshToken);

  // User
  static Future<void> saveUserRole(String role) async =>
      _instance.setString(AppConfig.keyUserRole, role);

  static String? getUserRole() => _instance.getString(AppConfig.keyUserRole);

  static Future<void> saveUserId(String id) async =>
      _instance.setString(AppConfig.keyUserId, id);

  static String? getUserId() => _instance.getString(AppConfig.keyUserId);

  // Onboarding
  static Future<void> setOnboardingDone() async =>
      _instance.setBool(AppConfig.keyOnboardingDone, true);

  static bool isOnboardingDone() =>
      _instance.getBool(AppConfig.keyOnboardingDone) ?? false;

  // Clear all (logout)
  static Future<void> clearAll() async => _instance.clear();

  static bool isLoggedIn() => getAccessToken() != null;
}
