import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProfile {
  final String userId, googleId, fullName, phoneNumber, photoUrl, emailAddress;

  UserProfile(
      {this.googleId,
      this.userId,
      this.fullName,
      this.emailAddress,
      this.phoneNumber,
      this.photoUrl});

  factory UserProfile.fromJSON({@required Map<String, String> jsonMap}) {
    return UserProfile(
        fullName: jsonMap['fullName'],
        emailAddress: jsonMap['emailAddress'],
        phoneNumber: jsonMap['phoneNumber'],
        userId: jsonMap['userId'],
        photoUrl: jsonMap['photoUrl']);
  }

  factory UserProfile.fromGoogleUser({@required User googleUser}) {
    return UserProfile(
        fullName: googleUser.displayName,
        emailAddress: googleUser.email,
        phoneNumber: googleUser.phoneNumber,
        googleId: googleUser.uid,
        photoUrl: googleUser.photoURL);
  }

  Map<String, String> get toJson => {
        'name': this.fullName,
        'phoneNumber': this.phoneNumber,
        'userId': this.userId,
        'email': this.emailAddress,
        'googleId': this.googleId
      };
}
