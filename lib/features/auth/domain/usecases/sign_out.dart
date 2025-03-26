import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';

class SignOut implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  SignOut(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}