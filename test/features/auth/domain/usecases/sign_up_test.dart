import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/auth/domain/entities/user.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_up.dart';

class MockAuthRepository extends Mock implements AuthRepository{}

void main() {
  final user = User(firstName: 'test', lastName: 'test', email: 'test@test.com');
  late MockAuthRepository mockAuthenticationRepository;
  late SignUp useCase;

  setUp(() {
    mockAuthenticationRepository = MockAuthRepository();
    useCase = SignUp(mockAuthenticationRepository);
  });

  test("should get user from the repository after succesfull sign out", () async {
    // arrange
    when(
      () => mockAuthenticationRepository.signUp(user)
    ).thenAnswer((_) async => Right(user));
    // act
    final result = await useCase(Params(user: user));
    // assert
    expect(result, Right(user));
    verify(() => mockAuthenticationRepository.signUp(user));
    verifyNoMoreInteractions(mockAuthenticationRepository);
  });
}
