class ApiConstants {
  ApiConstants._();

  // News API
  static const String newsApiKey = '8ba0edbae9ca4a32a77a09742835ea0f';
  static const String newsBaseUrl = 'https://newsapi.org/v2';
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // OpenWeather API
  static const String weatherApiKey = '422c09d453ede04e120d0b0b73dd53e4';
  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geoBaseUrl = 'https://api.openweathermap.org/geo/1.0';
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';
  static const String directGeocoding = '/direct';
}
