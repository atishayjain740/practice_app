import 'package:equatable/equatable.dart';

class User extends Equatable {
  late String firstName;
  late String lastName;
  late String email;

  User({required this.firstName, required this.lastName, required this.email});

  @override
  List<Object?> get props => [firstName, lastName, email];
  
}