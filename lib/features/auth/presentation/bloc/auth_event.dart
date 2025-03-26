import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;

  const SignInEvent({required this.email});
}

class SignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;

  const SignUpEvent({required this.firstName, required this.lastName, required this.email});
}

class SignOutEvent extends AuthEvent {

}