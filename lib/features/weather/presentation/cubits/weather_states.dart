import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/weather_entities.dart';

part 'weather_states.freezed.dart';

@Freezed()
class WeatherStates<T> with _$WeatherStates<T> {
  const factory WeatherStates.initial() = Initial;
  const factory WeatherStates.loading() = Loading;
  const factory WeatherStates.success({
    required WeatherEntity weather,
    required List<ForecastEntity> forecasts,
    required CityEntity city,
  }) = Success<T>;
  const factory WeatherStates.error({required String message}) = Error;
}
