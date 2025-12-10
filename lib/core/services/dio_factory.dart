import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';

class DioFactory {
  DioFactory._();

  static Dio? _newsApiDio;
  static Dio? _weatherApiDio;

  static Dio getNewsApiDio() {
    const Duration timeOut = Duration(seconds: 30);
    
    if (_newsApiDio == null) {
      _newsApiDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.newsBaseUrl,
          connectTimeout: timeOut,
          receiveTimeout: timeOut,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'X-Api-Key': ApiConstants.newsApiKey,
          },
        ),
      );

      _addDioInterceptor(_newsApiDio!);
      return _newsApiDio!;
    } else {
      return _newsApiDio!;
    }
  }

  static Dio getWeatherApiDio() {
    const Duration timeOut = Duration(seconds: 30);
    
    if (_weatherApiDio == null) {
      _weatherApiDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.weatherBaseUrl,
          connectTimeout: timeOut,
          receiveTimeout: timeOut,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      _addDioInterceptor(_weatherApiDio!);
      return _weatherApiDio!;
    } else {
      return _weatherApiDio!;
    }
  }

  static void _addDioInterceptor(Dio dio) {
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    ]);
  }
}
