import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/weather_entities.dart';

part 'weather_models.g.dart';

@JsonSerializable()
class WeatherModel {
  final MainModel? main;
  final List<WeatherDescModel>? weather;
  final WindModel? wind;
  final CloudsModel? clouds;
  final int? dt;

  WeatherModel({
    this.main,
    this.weather,
    this.wind,
    this.clouds,
    this.dt,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  WeatherEntity toEntity() {
    return WeatherEntity(
      temperature: main?.temp ?? 0,
      feelsLike: main?.feelsLike,
      tempMin: main?.tempMin,
      tempMax: main?.tempMax,
      pressure: main?.pressure,
      humidity: main?.humidity,
      weatherMain: weather?.first.main ?? 'Unknown',
      weatherDescription: weather?.first.description ?? 'Unknown',
      weatherIcon: weather?.first.icon ?? '01d',
      windSpeed: wind?.speed,
      windDeg: wind?.deg,
      clouds: clouds?.all,
      timestamp: dt != null
          ? DateTime.fromMillisecondsSinceEpoch(dt! * 1000)
          : DateTime.now(),
    );
  }
}

@JsonSerializable()
class MainModel {
  final double? temp;
  @JsonKey(name: 'feels_like')
  final double? feelsLike;
  @JsonKey(name: 'temp_min')
  final double? tempMin;
  @JsonKey(name: 'temp_max')
  final double? tempMax;
  final int? pressure;
  final int? humidity;

  MainModel({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) =>
      _$MainModelFromJson(json);

  Map<String, dynamic> toJson() => _$MainModelToJson(this);
}

@JsonSerializable()
class WeatherDescModel {
  final String? main;
  final String? description;
  final String? icon;

  WeatherDescModel({this.main, this.description, this.icon});

  factory WeatherDescModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherDescModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDescModelToJson(this);
}

@JsonSerializable()
class WindModel {
  final double? speed;
  final int? deg;

  WindModel({this.speed, this.deg});

  factory WindModel.fromJson(Map<String, dynamic> json) =>
      _$WindModelFromJson(json);

  Map<String, dynamic> toJson() => _$WindModelToJson(this);
}

@JsonSerializable()
class CloudsModel {
  final int? all;

  CloudsModel({this.all});

  factory CloudsModel.fromJson(Map<String, dynamic> json) =>
      _$CloudsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CloudsModelToJson(this);
}

@JsonSerializable()
class ForecastModel {
  final int? dt;
  final MainModel? main;
  final List<WeatherDescModel>? weather;
  final WindModel? wind;
  final CloudsModel? clouds;
  final double? pop;

  ForecastModel({
    this.dt,
    this.main,
    this.weather,
    this.wind,
    this.clouds,
    this.pop,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastModelToJson(this);

  ForecastEntity toEntity() {
    return ForecastEntity(
      dateTime: dt != null
          ? DateTime.fromMillisecondsSinceEpoch(dt! * 1000)
          : DateTime.now(),
      temperature: main?.temp ?? 0,
      feelsLike: main?.feelsLike,
      tempMin: main?.tempMin,
      tempMax: main?.tempMax,
      pressure: main?.pressure,
      humidity: main?.humidity,
      weatherMain: weather?.first.main ?? 'Unknown',
      weatherDescription: weather?.first.description ?? 'Unknown',
      weatherIcon: weather?.first.icon ?? '01d',
      windSpeed: wind?.speed,
      clouds: clouds?.all,
      pop: pop,
    );
  }
}

@JsonSerializable()
class ForecastResponse {
  final List<ForecastModel>? list;

  ForecastResponse({this.list});

  factory ForecastResponse.fromJson(Map<String, dynamic> json) =>
      _$ForecastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastResponseToJson(this);
}

class CityModel {
  final int? id;
  final String name;
  final String country;
  final double lat;
  final double lon;
  final bool isDefault;

  CityModel({
    this.id,
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    this.isDefault = false,
  });

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      country: map['country'] as String,
      lat: map['lat'] as double,
      lon: map['lon'] as double,
      isDefault: (map['is_default'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'country': country,
      'lat': lat,
      'lon': lon,
      'is_default': isDefault ? 1 : 0,
    };
  }

  CityEntity toEntity() {
    return CityEntity(
      id: id,
      name: name,
      country: country,
      lat: lat,
      lon: lon,
      isDefault: isDefault,
    );
  }

  factory CityModel.fromEntity(CityEntity entity) {
    return CityModel(
      id: entity.id,
      name: entity.name,
      country: entity.country,
      lat: entity.lat,
      lon: entity.lon,
      isDefault: entity.isDefault,
    );
  }
}
