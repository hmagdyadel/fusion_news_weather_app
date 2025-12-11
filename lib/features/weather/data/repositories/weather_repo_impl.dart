import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/helpers/logging_service.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather_entities.dart';
import '../../domain/repositories/weather_repo.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';
import '../models/weather_models.dart';

class WeatherRepoImpl implements WeatherRepo {
  final WeatherRemoteDatasource remoteDatasource;
  final WeatherLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  WeatherRepoImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return const Left(
        NetworkFailure('No internet connection'),
      );
    }

    try {
      final weather = await remoteDatasource.getCurrentWeather(
        lat: lat,
        lon: lon,
      );
      return Right(weather.toEntity());
    } on ServerException catch (e) {
      LoggingServicePrinter.log('❌ Weather Repo: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ForecastEntity>>> getForecast({
    required double lat,
    required double lon,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return const Left(
        NetworkFailure('No internet connection'),
      );
    }

    try {
      final forecasts = await remoteDatasource.getForecast(
        lat: lat,
        lon: lon,
      );
      return Right(forecasts.map((f) => f.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> searchCity(String query) async {
    // Simplified: return empty list (would need geocoding API)
    return const Right([]);
  }

  @override
  Future<Either<Failure, CityEntity>> saveCity(CityEntity city) async {
    try {
      final cityModel = await localDatasource.saveCity(
        CityModel.fromEntity(city),
      );
      return Right(cityModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultCity(int cityId) async {
    try {
      await localDatasource.setDefaultCity(cityId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> getSavedCities() async {
    try {
      final cities = await localDatasource.getSavedCities();
      return Right(cities.map((c) => c.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CityEntity?>> getDefaultCity() async {
    try {
      final city = await localDatasource.getDefaultCity();
      return Right(city?.toEntity());
    } catch (e) {
      return const Right(null);
    }
  }
}
