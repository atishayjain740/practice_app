import 'package:equatable/equatable.dart';
import 'package:practice_app/features/auth/domain/entities/user.dart';
 class AuthState extends Equatable{

  @override
  List<Object?> get props => [];
 }

 class AuthInitail extends AuthState{}

 class AuthLoading extends AuthState {}

 class AuthLoaded extends AuthState {
   final User user;

  AuthLoaded({required this.user});

 }

 class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
 }