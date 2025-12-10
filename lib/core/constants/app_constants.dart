class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Fusion News & Weather';
  static const String appVersion = '1.0.0';

  // Database
  static const String dbName = 'fusion_app.db';
  static const int dbVersion = 1;

  // SharedPreferences Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyDefaultCityId = 'default_city_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguageCode = 'language_code';

  // Pagination
  static const int newsPageSize = 20;
  static const int weatherForecastDays = 7;

  // Cache Duration
  static const Duration newsCacheDuration = Duration(hours: 1);
  static const Duration weatherCacheDuration = Duration(minutes: 30);
}
