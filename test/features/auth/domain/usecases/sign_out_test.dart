import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_out.dart';

class MockAuthRepository extends Mock implements AuthRepository{}

void main() {
  late MockAuthRepository mockAuthenticationRepository;
  late SignOut useCase;

  setUp(() {
    mockAuthenticationRepository = MockAuthRepository();
    useCase = SignOut(mockAuthenticationRepository);
  });

  test("should get true from the repository after succesfull sign out", () async {
    // arrange
    when(
      () => mockAuthenticationRepository.signOut()
    ).thenAnswer((_) async => Right(true));
    // act
    final result = await useCase(NoParams());
    // assert
    expect(result, Right(true));
    verify(() => mockAuthenticationRepository.signOut());
    verifyNoMoreInteractions(mockAuthenticationRepository);
  });
}
