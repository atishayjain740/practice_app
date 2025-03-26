import 'package:practice_app/core/user/entity/user.dart';

class UserModel extends User {
  UserModel({required super.firstName, required super.lastName, required super.email});

  UserModel.fromJson(Map<String, dynamic> json)
      : super(
          firstName: json['first-name'],
          lastName: json['last-name'],
          email: json['email'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first-name'] = firstName;
    data['last-name'] = lastName;
    data['email'] = email;
    return data;
  }
  
}