import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final double temperature;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final double? windSpeed;
  final int? windDeg;
  final int? clouds;
  final DateTime timestamp;

  const WeatherEntity({
    required this.temperature,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    this.windSpeed,
    this.windDeg,
    this.clouds,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        temperature,
        feelsLike,
        tempMin,
        tempMax,
        pressure,
        humidity,
        weatherMain,
        weatherDescription,
        weatherIcon,
        windSpeed,
        windDeg,
        clouds,
        timestamp,
      ];
}

class ForecastEntity extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final double? windSpeed;
  final int? clouds;
  final double? pop; // Probability of precipitation

  const ForecastEntity({
    required this.dateTime,
    required this.temperature,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    this.windSpeed,
    this.clouds,
    this.pop,
  });

  @override
  List<Object?> get props => [
        dateTime,
        temperature,
        feelsLike,
        tempMin,
        tempMax,
        pressure,
        humidity,
        weatherMain,
        weatherDescription,
        weatherIcon,
        windSpeed,
        clouds,
        pop,
      ];
}

class CityEntity extends Equatable {
  final int? id;
  final String name;
  final String country;
  final double lat;
  final double lon;
  final bool isDefault;

  const CityEntity({
    this.id,
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, country, lat, lon, isDefault];
}
