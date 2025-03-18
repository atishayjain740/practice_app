import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/network/netrwork_info.dart';
import 'package:practice_app/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:practice_app/features/counter/data/datasources/counter_remote_data_source.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterRemoteDataSource counterRemoteDataSource;
  final CounterLocalDataSource counterLocalDataSource;
  final NetworkInfo networkInfo;

  const CounterRepositoryImpl({
    required this.counterRemoteDataSource,
    required this.counterLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Counter>> getCounter() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await counterRemoteDataSource.getCounter();
        await counterLocalDataSource.cacheCounter(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedData = await counterLocalDataSource.getCounter();
        return Right(cachedData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
