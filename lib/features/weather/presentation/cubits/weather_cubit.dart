import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/logging_service.dart';
import '../../domain/entities/weather_entities.dart';
import '../../domain/usecases/weather_usecases.dart';
import 'weather_states.dart';

class WeatherCubit extends Cubit<WeatherStates> {
  final GetCurrentWeatherUsecase getCurrentWeatherUsecase;
  final GetForecastUsecase getForecastUsecase;

  WeatherCubit({
    required this.getCurrentWeatherUsecase,
    required this.getForecastUsecase,
  }) : super(const WeatherStates.initial());

  Future<void> fetchWeather(CityEntity city) async {
    emit(const WeatherStates.loading());

    LoggingServicePrinter.log('🌤️ Cubit: Fetching weather for ${city.name}');

    final params = WeatherParams(lat: city.lat, lon: city.lon);

    final weatherResult = await getCurrentWeatherUsecase(params);
    final forecastResult = await getForecastUsecase(params);

    weatherResult.fold(
      (failure) {
        LoggingServicePrinter.log('❌ Cubit: Weather failed - ${failure.message}');
        emit(WeatherStates.error(message: failure.message));
      },
      (weather) {
        forecastResult.fold(
          (failure) {
            LoggingServicePrinter.log('❌ Cubit: Forecast failed - ${failure.message}');
            emit(WeatherStates.success(
              weather: weather,
              forecasts: [],
              city: city,
            ));
          },
          (forecasts) {
            LoggingServicePrinter.log('✅ Cubit: Weather & forecast loaded');
            emit(WeatherStates.success(
              weather: weather,
              forecasts: forecasts,
              city: city,
            ));
          },
        );
      },
    );
  }

  void resetState() {
    emit(const WeatherStates.initial());
  }
}
