import 'package:sqflite/sqflite.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/helpers/logging_service.dart';
import '../../../../core/services/database_service.dart';
import '../models/weather_models.dart';

abstract class WeatherLocalDatasource {
  Future<CityModel> saveCity(CityModel city);
  Future<void> setDefaultCity(int cityId);
  Future<List<CityModel>> getSavedCities();
  Future<CityModel?> getDefaultCity();
}

class WeatherLocalDatasourceImpl implements WeatherLocalDatasource {
  @override
  Future<CityModel> saveCity(CityModel city) async {
    try {
      final db = await DatabaseService.database;

      final id = await db.insert(
        'cities',
        city.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      LoggingServicePrinter.log('✅ City saved: ${city.name}');

      return CityModel(
        id: id,
        name: city.name,
        country: city.country,
        lat: city.lat,
        lon: city.lon,
        isDefault: city.isDefault,
      );
    } catch (e) {
      LoggingServicePrinter.logError('❌ Failed to save city', error: e);
      throw CacheException('Failed to save city');
    }
  }

  @override
  Future<void> setDefaultCity(int cityId) async {
    try {
      final db = await DatabaseService.database;

      await db.transaction((txn) async {
        // Remove default from all cities
        await txn.update(
          'cities',
          {'is_default': 0},
        );

        // Set new default
        await txn.update(
          'cities',
          {'is_default': 1},
          where: 'id = ?',
          whereArgs: [cityId],
        );
      });

      LoggingServicePrinter.log('✅ Default city set: $cityId');
    } catch (e) {
      LoggingServicePrinter.logError('❌ Failed to set default city', error: e);
      throw CacheException('Failed to set default city');
    }
  }

  @override
  Future<List<CityModel>> getSavedCities() async {
    try {
      final db = await DatabaseService.database;

      final List<Map<String, dynamic>> maps = await db.query('cities');

      return maps.map((map) => CityModel.fromMap(map)).toList();
    } catch (e) {
      LoggingServicePrinter.logError('❌ Failed to get saved cities', error: e);
      throw CacheException('Failed to retrieve saved cities');
    }
  }

  @override
  Future<CityModel?> getDefaultCity() async {
    try {
      final db = await DatabaseService.database;

      final List<Map<String, dynamic>> maps = await db.query(
        'cities',
        where: 'is_default = ?',
        whereArgs: [1],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      return CityModel.fromMap(maps.first);
    } catch (e) {
      LoggingServicePrinter.logError('❌ Failed to get default city', error: e);
      return null;
    }
  }
}
