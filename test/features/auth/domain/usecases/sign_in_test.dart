import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/user/entity/user.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_in.dart';

class MockAuthRepository extends Mock implements AuthRepository{}

void main() {
  final String email = 'test@test.com';
  final user = User(firstName: 'test', lastName: 'test', email: 'test@test.com');
  late MockAuthRepository mockAuthenticationRepository;
  late SignIn useCase;

  setUp(() {
    mockAuthenticationRepository = MockAuthRepository();
    useCase = SignIn(mockAuthenticationRepository);
  });

  test("should get user from the repository", () async {
    // arrange
    when(
      () => mockAuthenticationRepository.signIn(email)
    ).thenAnswer((_) async => Right(user));
    // act
    final result = await useCase(Params(email: email));
    // assert
    expect(result, Right(user));
    verify(() => mockAuthenticationRepository.signIn(email));
    verifyNoMoreInteractions(mockAuthenticationRepository);
  });
}
