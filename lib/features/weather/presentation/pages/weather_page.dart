import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/weather_entities.dart';
import '../cubits/weather_cubit.dart';
import '../cubits/weather_states.dart';
import '../widgets/temperature_chart.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    // Default city (Cairo)
    final defaultCity = CityEntity(
      name: 'Cairo',
      country: 'EG',
      lat: 30.0444,
      lon: 31.2357,
    );
    context.read<WeatherCubit>().fetchWeather(defaultCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('weather'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final state = context.read<WeatherCubit>().state;
              if (state is Success) {
                context.read<WeatherCubit>().fetchWeather(state.city);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherStates>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(child: Text('select_city'.tr())),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (weather, forecasts, city) {
              return RefreshIndicator(
                onRefresh: () => context.read<WeatherCubit>().fetchWeather(city),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // City name
                      Text(
                        '${city.name}, ${city.country}',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Current weather card
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${weather.temperature.toStringAsFixed(1)}°C',
                                        style: TextStyle(
                                          fontSize: 48.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        weather.weatherDescription,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    _getWeatherIcon(weather.weatherMain),
                                    size: 80.sp,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _WeatherDetail(
                                    icon: Icons.thermostat,
                                    label: 'feels_like'.tr(),
                                    value: '${weather.feelsLike?.toStringAsFixed(1) ?? '--'}°C',
                                  ),
                                  _WeatherDetail(
                                    icon: Icons.water_drop,
                                    label: 'humidity'.tr(),
                                    value: '${weather.humidity ?? '--'}%',
                                  ),
                                  _WeatherDetail(
                                    icon: Icons.air,
                                    label: 'wind_speed'.tr(),
                                    value: '${weather.windSpeed?.toStringAsFixed(1) ?? '--'} m/s',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Temperature chart
                      if (forecasts.isNotEmpty) ...[
                        Text(
                          'hourly_forecast'.tr(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 200.h,
                          child: TemperatureChart(
                            forecasts: forecasts.take(24).toList(),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Daily forecast
                      if (forecasts.isNotEmpty) ...[
                        Text(
                          'daily_forecast'.tr(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ...forecasts
                            .where((f) => f.dateTime.hour == 12)
                            .take(7)
                            .map((forecast) => _ForecastCard(forecast: forecast)),
                      ],
                    ],
                  ),
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      final defaultCity = CityEntity(
                        name: 'Cairo',
                        country: 'EG',
                        lat: 30.0444,
                        lon: 31.2357,
                      );
                      context.read<WeatherCubit>().fetchWeather(defaultCity);
                    },
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24.sp),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final ForecastEntity forecast;

  const _ForecastCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Icon(Icons.wb_sunny, size: 32.sp),
        title: Text(DateFormat.MMMd().format(forecast.dateTime)),
        subtitle: Text(forecast.weatherDescription),
        trailing: Text(
          '${forecast.temperature.toStringAsFixed(1)}°C',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
