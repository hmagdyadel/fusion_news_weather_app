import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather_entities.dart';
import '../repositories/weather_repo.dart';

class GetCurrentWeatherUsecase
    implements UseCase<WeatherEntity, WeatherParams> {
  final WeatherRepo repository;

  GetCurrentWeatherUsecase({required this.repository});

  @override
  Future<Either<Failure, WeatherEntity>> call(WeatherParams params) async {
    return await repository.getCurrentWeather(
      lat: params.lat,
      lon: params.lon,
    );
  }
}

class GetForecastUsecase
    implements UseCase<List<ForecastEntity>, WeatherParams> {
  final WeatherRepo repository;

  GetForecastUsecase({required this.repository});

  @override
  Future<Either<Failure, List<ForecastEntity>>> call(
    WeatherParams params,
  ) async {
    return await repository.getForecast(
      lat: params.lat,
      lon: params.lon,
    );
  }
}

class WeatherParams extends Equatable {
  final double lat;
  final double lon;

  const WeatherParams({
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [lat, lon];
}
