import 'package:flutter/widgets.dart';

class UserProfile {
  final String userId,
      fullName,
      phoneNumber,
      password,
      emailAddress,
      city,
      state;

  UserProfile(
      {this.userId,
      this.fullName,
      this.emailAddress,
      this.password,
      this.phoneNumber,
      this.city,
      this.state});

  factory UserProfile.fromJson({@required Map<String, String> jsonMap}) {
    return new UserProfile(
        fullName: jsonMap['name'],
        phoneNumber: jsonMap['phoneNumber'],
        password: jsonMap['password'],
        emailAddress: jsonMap['email'],
        userId: jsonMap['userId'],
        city: jsonMap['city'],
        state: jsonMap['state']);
  }

  Map<String, String> toJson() {
    return {
      'name': this.fullName,
      'phoneNumber': this.phoneNumber,
      'userId': this.userId,
      'email': this.emailAddress,
      'password': this.password,
      'city': this.city,
      'state': this.state
    };
  }
}
