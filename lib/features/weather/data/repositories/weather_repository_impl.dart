import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/network/netrwork_info.dart';
import 'package:practice_app/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:practice_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:practice_app/features/weather/domain/entities/weather.dart';
import 'package:practice_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository{
  final WeatherLocalDataSource localDataSource;
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const WeatherRepositoryImpl({required this.localDataSource, required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, Weather>> getWeather() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getWeather();
        await localDataSource.cacheWeather(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedData = await localDataSource.getWeather();
        return Right(cachedData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}