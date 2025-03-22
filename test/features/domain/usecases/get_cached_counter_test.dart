import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:practice_app/features/counter/domain/usecases/get_cached_counter.dart';

class MockCounterRepository extends Mock implements CounterRepository{}

void main() {
  final counter = Counter(count: 0);
  late MockCounterRepository mockCounterRepository;
  late GetCachedCounter useCase;

  setUp(() {
    mockCounterRepository = MockCounterRepository();
    useCase = GetCachedCounter(mockCounterRepository);
  });

  test("should get count from the cached repository", () async {
    // arrange
    when(
      () => mockCounterRepository.getCachedCounter(),
    ).thenAnswer((_) async => Right(counter));
    // act
    final result = await useCase(NoParams());
    // assert
    expect(result, Right(counter));
    verify(() => mockCounterRepository.getCachedCounter());
    verifyNoMoreInteractions(mockCounterRepository);
  });
}
