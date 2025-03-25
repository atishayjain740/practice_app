import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/authentication/domain/entities/user.dart';
import 'package:practice_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:practice_app/features/authentication/domain/usecases/sign_up.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository{}

void main() {
  final user = User(firstName: 'test', lastName: 'test', email: 'test@test.com');
  late MockAuthenticationRepository mockAuthenticationRepository;
  late SignUp useCase;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
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
