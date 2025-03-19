import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/network/netrwork_info.dart';
import 'package:practice_app/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:practice_app/features/counter/data/datasources/counter_remote_data_source.dart';
import 'package:practice_app/features/counter/data/models/counter_model.dart';
import 'package:practice_app/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';

import 'counter_repository_impl_test.mocks.dart';

@GenerateMocks([CounterLocalDataSource, CounterRemoteDataSource, NetworkInfo])
void main() {
  late CounterRepositoryImpl counterRepositoryImpl;
  late MockCounterLocalDataSource mockCounterLocalDataSource;
  late MockCounterRemoteDataSource mockCounterRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockCounterLocalDataSource = MockCounterLocalDataSource();
    mockCounterRemoteDataSource = MockCounterRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    counterRepositoryImpl = CounterRepositoryImpl(
      counterRemoteDataSource: mockCounterRemoteDataSource,
      counterLocalDataSource: mockCounterLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('get cached counter', () {
    int count = 0;
    CounterModel counterModel = CounterModel(count: count);
    Counter counter = counterModel;
    test(
      "should return the last locally cached data when the cached data is present",
      () async {
        // arrange
        when(
          mockCounterLocalDataSource.getCounter(),
        ).thenAnswer((_) async => counterModel);
        // act
        final result = await counterRepositoryImpl.getCachedCounter();
        // assert
        verifyZeroInteractions(mockCounterRemoteDataSource);
        verify(mockCounterLocalDataSource.getCounter());
        expect(result, equals(Right(counter)));
      },
    );

    test(
      "should return CacheFailure when the cached data is not present",
      () async {
        // arrange
        when(
          mockCounterLocalDataSource.getCounter(),
        ).thenThrow(CacheException());
        // act
        final result = await counterRepositoryImpl.getCachedCounter();
        // assert
        verifyZeroInteractions(mockCounterRemoteDataSource);
        verify(mockCounterLocalDataSource.getCounter());
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });

  group("get counter", () {
    int count = 0;
    CounterModel counterModel = CounterModel(count: count);
    Counter counter = counterModel;

    test("should check if the device is online", () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockCounterRemoteDataSource.getCounter(),
      ).thenAnswer((_) async => counterModel);
      // act
      await counterRepositoryImpl.getCounter();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    test("should save the counter and return it", () async {
      // arrange
      when(
        mockCounterLocalDataSource.getCounter(),
      ).thenAnswer((_) async => counterModel);
      // act
      final result = await counterRepositoryImpl.saveCounter(counterModel);
      // assert
      verifyZeroInteractions(mockCounterRemoteDataSource);
      verify(mockCounterLocalDataSource.cacheCounter(counterModel));
      expect(result, equals(Right(counter)));
    });

    test("should return failure when caching data is unsuccesfull", () async {
      // arrange
      when(
        mockCounterLocalDataSource.cacheCounter(counterModel),
      ).thenThrow(CacheException());

      // act
      final result = await counterRepositoryImpl.saveCounter(counterModel);
      // assert
      verify(mockCounterLocalDataSource.cacheCounter(counterModel));
      verifyZeroInteractions(mockCounterRemoteDataSource);
      expect(result, Left(CacheFailure()));
    });

    group("device online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        "should return remote data when call to remote data is success",
        () async {
          // arrange
          when(
            mockCounterRemoteDataSource.getCounter(),
          ).thenAnswer((_) async => counterModel);
          // act
          final result = await counterRepositoryImpl.getCounter();
          // assert
          verify(mockCounterRemoteDataSource.getCounter());
          expect(result, equals(Right(counter)));
        },
      );

      test(
        "should cache remote data locally when call to remote data is success",
        () async {
          // arrange
          when(
            mockCounterRemoteDataSource.getCounter(),
          ).thenAnswer((_) async => counterModel);
          // act
          await counterRepositoryImpl.getCounter();
          // assert
          verify(mockCounterLocalDataSource.cacheCounter(counterModel));
        },
      );

      test(
        "should return server exception when call to remote data is unsuccessful",
        () async {
          // arrange
          when(
            mockCounterRemoteDataSource.getCounter(),
          ).thenThrow(ServerException());
          // act
          final result = await counterRepositoryImpl.getCounter();
          // assert
          verify(mockCounterRemoteDataSource.getCounter());
          verifyZeroInteractions(mockCounterLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });

    group("device offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        "should return the last locally cached data when the cached data is present",
        () async {
          // arrange
          when(
            mockCounterLocalDataSource.getCounter(),
          ).thenAnswer((_) async => counterModel);
          // act
          final result = await counterRepositoryImpl.getCounter();
          // assert
          verifyZeroInteractions(mockCounterRemoteDataSource);
          verify(mockCounterLocalDataSource.getCounter());
          expect(result, equals(Right(counter)));
        },
      );

      test(
        "should return CacheFailure when the cached data is not present",
        () async {
          // arrange
          when(
            mockCounterLocalDataSource.getCounter(),
          ).thenThrow(CacheException());
          // act
          final result = await counterRepositoryImpl.getCounter();
          // assert
          verifyZeroInteractions(mockCounterRemoteDataSource);
          verify(mockCounterLocalDataSource.getCounter());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
