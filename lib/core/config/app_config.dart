class AppConfig {
  AppConfig._();

  // API
  static const String baseUrl = 'http://localhost:3000';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // App
  static const String appName = 'Jastip Wirosari';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserRole = 'user_role';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingDone = 'onboarding_done';

  // Pricing
  static const double serviceFeePercentage = 0.05; // 5%
  static const double minServiceFee = 2000;
  static const double maxServiceFee = 10000;
}
