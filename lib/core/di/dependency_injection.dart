import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubits/login/login_cubit.dart';
import '../../features/auth/presentation/cubits/register/register_cubit.dart';
import '../../features/news/data/datasources/news_local_datasource.dart';
import '../../features/news/data/datasources/news_remote_datasource.dart';
import '../../features/news/data/repositories/news_repo_impl.dart';
import '../../features/news/domain/repositories/news_repo.dart';
import '../../features/news/domain/usecases/get_cached_news_usecase.dart';
import '../../features/news/domain/usecases/get_top_headlines_usecase.dart';
import '../../features/news/domain/usecases/search_news_usecase.dart';
import '../../features/news/presentation/cubits/news_cubit.dart';
import '../../features/weather/data/datasources/weather_local_datasource.dart';
import '../../features/weather/data/datasources/weather_remote_datasource.dart';
import '../../features/weather/data/repositories/weather_repo_impl.dart';
import '../../features/weather/domain/repositories/weather_repo.dart';
import '../../features/weather/domain/usecases/weather_usecases.dart';
import '../../features/weather/presentation/cubits/weather_cubit.dart';
import '../helpers/logging_service.dart';
import '../network/network_info.dart';
import '../services/database_service.dart';
import '../services/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  LoggingServicePrinter.log('🔧 Setting up dependency injection...');

  // Initialize database
  await DatabaseService.database;
  LoggingServicePrinter.log('✅ Database initialized');

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  final connectivity = Connectivity();
  getIt.registerLazySingleton<Connectivity>(() => connectivity);

  // Network
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(getIt<Connectivity>()),
  );

  // Dio instances
  final newsApiDio = DioFactory.getNewsApiDio();
  final weatherApiDio = DioFactory.getWeatherApiDio();
  getIt.registerLazySingleton<Dio>(() => newsApiDio, instanceName: 'newsApi');
  getIt.registerLazySingleton<Dio>(
    () => weatherApiDio,
    instanceName: 'weatherApi',
  );

  // ========== Authentication Feature ==========

  // Datasources
  getIt.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(localDatasource: getIt<AuthLocalDatasource>()),
  );

  // Use cases
  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(repository: getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(repository: getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<CheckAuthUsecase>(
    () => CheckAuthUsecase(repository: getIt<AuthRepo>()),
  );

  // Cubits
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(loginUsecase: getIt<LoginUsecase>()),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(registerUsecase: getIt<RegisterUsecase>()),
  );

  // ========== News Feature ==========

  // Datasources
  getIt.registerLazySingleton<NewsRemoteDatasource>(
    () => NewsRemoteDatasourceImpl(dio: getIt<Dio>(instanceName: 'newsApi')),
  );
  getIt.registerLazySingleton<NewsLocalDatasource>(
    () => NewsLocalDatasourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<NewsRepo>(
    () => NewsRepoImpl(
      remoteDatasource: getIt<NewsRemoteDatasource>(),
      localDatasource: getIt<NewsLocalDatasource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetTopHeadlinesUsecase>(
    () => GetTopHeadlinesUsecase(repository: getIt<NewsRepo>()),
  );
  getIt.registerLazySingleton<SearchNewsUsecase>(
    () => SearchNewsUsecase(repository: getIt<NewsRepo>()),
  );
  getIt.registerLazySingleton<GetCachedNewsUsecase>(
    () => GetCachedNewsUsecase(repository: getIt<NewsRepo>()),
  );

  // Cubits
  getIt.registerFactory<NewsCubit>(
    () => NewsCubit(
      getTopHeadlinesUsecase: getIt<GetTopHeadlinesUsecase>(),
      searchNewsUsecase: getIt<SearchNewsUsecase>(),
      getCachedNewsUsecase: getIt<GetCachedNewsUsecase>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // ========== Weather Feature ==========

  // Datasources
  getIt.registerLazySingleton<WeatherRemoteDatasource>(
    () => WeatherRemoteDatasourceImpl(dio: getIt<Dio>(instanceName: 'weatherApi')),
  );
  getIt.registerLazySingleton<WeatherLocalDatasource>(
    () => WeatherLocalDatasourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<WeatherRepo>(
    () => WeatherRepoImpl(
      remoteDatasource: getIt<WeatherRemoteDatasource>(),
      localDatasource: getIt<WeatherLocalDatasource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetCurrentWeatherUsecase>(
    () => GetCurrentWeatherUsecase(repository: getIt<WeatherRepo>()),
  );
  getIt.registerLazySingleton<GetForecastUsecase>(
    () => GetForecastUsecase(repository: getIt<WeatherRepo>()),
  );

  // Cubits
  getIt.registerFactory<WeatherCubit>(
    () => WeatherCubit(
      getCurrentWeatherUsecase: getIt<GetCurrentWeatherUsecase>(),
      getForecastUsecase: getIt<GetForecastUsecase>(),
    ),
  );

  LoggingServicePrinter.log('✅ Dependency injection setup complete');
}
