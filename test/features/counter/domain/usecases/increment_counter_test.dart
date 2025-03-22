import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:practice_app/features/counter/domain/usecases/increment_counter.dart';

class MockCounterRepository extends Mock implements CounterRepository{}

void main() {
  late MockCounterRepository mockCounterRepository;
  late IncrementCounter useCase;

  setUp(() {
    mockCounterRepository = MockCounterRepository();
    useCase = IncrementCounter(mockCounterRepository);
  });

  test('should increment count and save in the repository', () async {
    Counter initialCounter = Counter(count: 0);
    Counter expectedCounter = Counter(count: 1);
    // arrange
    when(
      () => mockCounterRepository.saveCounter(expectedCounter),
    ).thenAnswer((_) async => Right(expectedCounter));
    // act
    final result = await useCase(Params(counter: initialCounter));
    // assert
    verify(() => mockCounterRepository.saveCounter(expectedCounter));
    expect(result, Right(expectedCounter));
  });

  test('should return failure when repository fails', () async {
    Counter initialCounter = Counter(count: 0);
    Counter expectedCounter = Counter(count: 1);
    // arrange
    when(
      () => mockCounterRepository.saveCounter(expectedCounter),
    ).thenAnswer((_) async => Left(CacheFailure()));
    // act
    final result = await useCase(Params(counter: initialCounter));
    // assert
    verify(() => mockCounterRepository.saveCounter(expectedCounter));
    expect(result, Left(CacheFailure()));
  });
}
