import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice_app/core/network/netrwork_info.dart';
import 'package:practice_app/core/user/user_session_manager.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_cache_data_source.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_db_data_source.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_file_data_source.dart';
import 'package:practice_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_in.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_out.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_up.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:practice_app/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:practice_app/features/counter/data/datasources/counter_remote_data_source.dart';
import 'package:practice_app/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:practice_app/features/counter/domain/usecases/decrement_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_cached_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/increment_counter.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:practice_app/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:practice_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:practice_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:practice_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:practice_app/features/weather/domain/usecases/get_weather.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // features - Auth
  // bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signOut: sl(),
      signUp: sl()
    ),
  );

  // usecases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      userSessionManager: sl(),
      cacheDataSource: sl(),
      dbDataSource: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<UserLocalCacheDataSource>(
    () => UserLocalCacheDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<UserLocalFileDataSource>(
    () => UserLocalFileDataSourceImpl(file: sl()),
  );

  final Database database = await initUserDb();
  sl.registerLazySingleton<Database>(() => database);
  sl.registerLazySingleton<UserLocalDBDataSource>(
    () => UserLocalDatabaseDataSourceImpl(database: sl<Database>()),
  );


  // features - Counter
  // bloc
  sl.registerFactory(
    () => CounterBloc(
      getCounter: sl(),
      incrementCounter: sl(),
      decrementCounter: sl(),
      getCachedCounter: sl(),
    ),
  );

  // usecases
  sl.registerLazySingleton(() => GetCounter(sl()));
  sl.registerLazySingleton(() => IncrementCounter(sl()));
  sl.registerLazySingleton(() => DecrementCounter(sl()));
  sl.registerLazySingleton(() => GetCachedCounter(sl()));

  // Repositories
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(
      counterRemoteDataSource: sl(),
      counterLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<CounterRemoteDataSource>(
    () => CounterRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<CounterLocalDataSource>(
    () => CounterLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // features - Weather
  // bloc
  sl.registerFactory(
    () => WeatherBloc(
      getWeather: sl(),
    ),
  );

  // usecases
  sl.registerLazySingleton(() => GetWeather(sl()));

  // Repositories
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(sharedPreferences: sl()),
  );


  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  
  Directory dir = await getApplicationDocumentsDirectory();
  File file = File("${dir.path}/users.json");
  sl.registerLazySingleton(() => file);

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => InternetConnection());

  // core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connection: sl()),
  );
  final userSession = UserSessionManager(sl());
  await userSession.init();
  sl.registerSingleton<UserSessionManager>(userSession);
}
