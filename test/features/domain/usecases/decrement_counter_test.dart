import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:practice_app/features/counter/domain/usecases/decrement_counter.dart';

import 'increment_counter_test.mocks.dart';

@GenerateMocks([CounterRepository])
void main() {
  late MockCounterRepository mockCounterRepository;
  late DecrementCounter useCase;

  setUp(() {
    mockCounterRepository = MockCounterRepository();
    useCase = DecrementCounter(mockCounterRepository);
  });

  test('should decrement count and save in the repository', () async {
    Counter initialCounter = Counter(count: 1);
    Counter expectedCounter = Counter(count: 0);
    // arrange
    when(
      mockCounterRepository.saveCounter(expectedCounter),
    ).thenAnswer((_) async => Right(expectedCounter));
    // act
    final result = await useCase(Params(counter: initialCounter));
    // assert
    verify(mockCounterRepository.saveCounter(expectedCounter));
    expect(result, Right(expectedCounter));
  });

  test('should return failure when repository fails', () async {
    Counter initialCounter = Counter(count: 1);
    Counter expectedCounter = Counter(count: 0);
    // arrange
    when(
      mockCounterRepository.saveCounter(expectedCounter),
    ).thenAnswer((_) async => Left(CacheFailure()));
    // act
    final result = await useCase(Params(counter: initialCounter));
    // assert
    verify(mockCounterRepository.saveCounter(expectedCounter));
    expect(result, Left(CacheFailure()));
  });
}
