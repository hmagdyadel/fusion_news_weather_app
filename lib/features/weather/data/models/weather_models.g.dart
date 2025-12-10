// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
  main: json['main'] == null
      ? null
      : MainModel.fromJson(json['main'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>?)
      ?.map((e) => WeatherDescModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  wind: json['wind'] == null
      ? null
      : WindModel.fromJson(json['wind'] as Map<String, dynamic>),
  clouds: json['clouds'] == null
      ? null
      : CloudsModel.fromJson(json['clouds'] as Map<String, dynamic>),
  dt: (json['dt'] as num?)?.toInt(),
);

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'main': instance.main,
      'weather': instance.weather,
      'wind': instance.wind,
      'clouds': instance.clouds,
      'dt': instance.dt,
    };

MainModel _$MainModelFromJson(Map<String, dynamic> json) => MainModel(
  temp: (json['temp'] as num?)?.toDouble(),
  feelsLike: (json['feels_like'] as num?)?.toDouble(),
  tempMin: (json['temp_min'] as num?)?.toDouble(),
  tempMax: (json['temp_max'] as num?)?.toDouble(),
  pressure: (json['pressure'] as num?)?.toInt(),
  humidity: (json['humidity'] as num?)?.toInt(),
);

Map<String, dynamic> _$MainModelToJson(MainModel instance) => <String, dynamic>{
  'temp': instance.temp,
  'feels_like': instance.feelsLike,
  'temp_min': instance.tempMin,
  'temp_max': instance.tempMax,
  'pressure': instance.pressure,
  'humidity': instance.humidity,
};

WeatherDescModel _$WeatherDescModelFromJson(Map<String, dynamic> json) =>
    WeatherDescModel(
      main: json['main'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$WeatherDescModelToJson(WeatherDescModel instance) =>
    <String, dynamic>{
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };

WindModel _$WindModelFromJson(Map<String, dynamic> json) => WindModel(
  speed: (json['speed'] as num?)?.toDouble(),
  deg: (json['deg'] as num?)?.toInt(),
);

Map<String, dynamic> _$WindModelToJson(WindModel instance) => <String, dynamic>{
  'speed': instance.speed,
  'deg': instance.deg,
};

CloudsModel _$CloudsModelFromJson(Map<String, dynamic> json) =>
    CloudsModel(all: (json['all'] as num?)?.toInt());

Map<String, dynamic> _$CloudsModelToJson(CloudsModel instance) =>
    <String, dynamic>{'all': instance.all};

ForecastModel _$ForecastModelFromJson(Map<String, dynamic> json) =>
    ForecastModel(
      dt: (json['dt'] as num?)?.toInt(),
      main: json['main'] == null
          ? null
          : MainModel.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>?)
          ?.map((e) => WeatherDescModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      wind: json['wind'] == null
          ? null
          : WindModel.fromJson(json['wind'] as Map<String, dynamic>),
      clouds: json['clouds'] == null
          ? null
          : CloudsModel.fromJson(json['clouds'] as Map<String, dynamic>),
      pop: (json['pop'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ForecastModelToJson(ForecastModel instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'main': instance.main,
      'weather': instance.weather,
      'wind': instance.wind,
      'clouds': instance.clouds,
      'pop': instance.pop,
    };

ForecastResponse _$ForecastResponseFromJson(Map<String, dynamic> json) =>
    ForecastResponse(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => ForecastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ForecastResponseToJson(ForecastResponse instance) =>
    <String, dynamic>{'list': instance.list};
