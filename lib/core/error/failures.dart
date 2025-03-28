import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class FileFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class DBFailure extends Failure {
  @override
  List<Object?> get props => [];
}