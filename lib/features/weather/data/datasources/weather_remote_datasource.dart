import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/helpers/logging_service.dart';
import '../models/weather_models.dart';

abstract class WeatherRemoteDatasource {
  Future<WeatherModel> getCurrentWeather({
    required double lat,
    required double lon,
  });

  Future<List<ForecastModel>> getForecast({
    required double lat,
    required double lon,
  });
}

class WeatherRemoteDatasourceImpl implements WeatherRemoteDatasource {
  final Dio dio;

  WeatherRemoteDatasourceImpl({required this.dio});

  @override
  Future<WeatherModel> getCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      LoggingServicePrinter.log('🌤️ Fetching weather for lat: $lat, lon: $lon');

      final response = await dio.get(
        ApiConstants.currentWeather,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': ApiConstants.weatherApiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        final weather = WeatherModel.fromJson(response.data);
        LoggingServicePrinter.log('✅ Weather fetched successfully');
        return weather;
      } else {
        throw ServerException('Failed to fetch weather: ${response.statusCode}');
      }
    } on DioException catch (e) {
      LoggingServicePrinter.logError('❌ Dio error', error: e);
      throw ServerException(e.message ?? 'Network error occurred');
    } catch (e) {
      LoggingServicePrinter.logError('❌ Unexpected error', error: e);
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<ForecastModel>> getForecast({
    required double lat,
    required double lon,
  }) async {
    try {
      LoggingServicePrinter.log('📅 Fetching forecast for lat: $lat, lon: $lon');

      final response = await dio.get(
        ApiConstants.forecast,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': ApiConstants.weatherApiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        final forecastResponse = ForecastResponse.fromJson(response.data);
        LoggingServicePrinter.log(
          '✅ Forecast fetched: ${forecastResponse.list?.length ?? 0} items',
        );
        return forecastResponse.list ?? [];
      } else {
        throw ServerException('Failed to fetch forecast: ${response.statusCode}');
      }
    } on DioException catch (e) {
      LoggingServicePrinter.logError('❌ Dio error', error: e);
      throw ServerException(e.message ?? 'Network error occurred');
    } catch (e) {
      LoggingServicePrinter.logError('❌ Unexpected error', error: e);
      throw ServerException('An unexpected error occurred');
    }
  }
}
