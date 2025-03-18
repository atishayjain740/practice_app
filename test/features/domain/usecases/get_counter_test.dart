import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:practice_app/features/counter/domain/usecases/get_counter.dart';
import 'package:mockito/annotations.dart';
import 'get_counter_test.mocks.dart';

@GenerateMocks([CounterRepository])
void main() {
  final counter = Counter(count: 0);
  late MockCounterRepository mockCounterRepository;
  late GetCounter useCase;

  setUp(() {
    mockCounterRepository = MockCounterRepository();
    useCase = GetCounter(mockCounterRepository);
  });

  test("should get count from the repository", () async {
    // arrange
    when(
      mockCounterRepository.getCounter(),
    ).thenAnswer((_) async => Right(counter));
    // act
    final result = await useCase(NoParams());
    // assert
    expect(result, Right(counter));
    verify(mockCounterRepository.getCounter());
    verifyNoMoreInteractions(mockCounterRepository);
  });
}
