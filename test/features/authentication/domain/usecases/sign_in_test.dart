import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/authentication/domain/entities/user.dart';
import 'package:practice_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:practice_app/features/authentication/domain/usecases/sign_in.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository{}

void main() {
  final String email = 'test@test.com';
  final user = User(firstName: 'test', lastName: 'test', email: 'test@test.com');
  late MockAuthenticationRepository mockAuthenticationRepository;
  late SignIn useCase;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
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
