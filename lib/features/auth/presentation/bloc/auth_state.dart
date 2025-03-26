import 'package:equatable/equatable.dart';
import 'package:practice_app/core/user/entity/user.dart';
 class AuthState extends Equatable{

  @override
  List<Object?> get props => [];
 }

 class AuthInitail extends AuthState{}

 class AuthLoading extends AuthState {}

 class AuthSignOut extends AuthState {}

 class AuthLoaded extends AuthState {
   final User user;

  AuthLoaded({required this.user});

 }

 class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
 }