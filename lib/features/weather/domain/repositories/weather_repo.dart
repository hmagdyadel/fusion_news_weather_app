import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather_entities.dart';

abstract class WeatherRepo {
  Future<Either<Failure, WeatherEntity>> getCurrentWeather({
    required double lat,
    required double lon,
  });

  Future<Either<Failure, List<ForecastEntity>>> getForecast({
    required double lat,
    required double lon,
  });

  Future<Either<Failure, List<CityEntity>>> searchCity(String query);

  Future<Either<Failure, CityEntity>> saveCity(CityEntity city);

  Future<Either<Failure, void>> setDefaultCity(int cityId);

  Future<Either<Failure, List<CityEntity>>> getSavedCities();

  Future<Either<Failure, CityEntity?>> getDefaultCity();
}
