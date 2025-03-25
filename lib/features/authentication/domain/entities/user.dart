import 'package:equatable/equatable.dart';

class User extends Equatable {
  String? firstName;
  String? lastName;
  String? email;

  User({this.firstName, this.lastName, this.email});
  
  @override
  List<Object?> get props => [firstName, lastName, email];
}
