import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_crime_report/models/userProfile.dart';

class GoogleAuth {
  Future<UserProfile> signInWithGoogle({BuildContext context}) async {
    UserProfile _userProfile = new UserProfile();

    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount _googleSignInAccount =
        await _googleSignIn.signIn();

    if (_googleSignInAccount != null) {
      final GoogleSignInAuthentication _googleSignInAuthentication =
          await _googleSignInAccount.authentication;

      final AuthCredential _credentials = GoogleAuthProvider.credential(
          accessToken: _googleSignInAuthentication.accessToken,
          idToken: _googleSignInAuthentication.idToken);

      try {
        final UserCredential _userCredential =
            await _auth.signInWithCredential(_credentials);

        User _googleUser = _userCredential.user;

        _userProfile = UserProfile.fromGoogleUser(googleUser: _googleUser);
      } catch (exception) {
        print(
            '<<<<<<<<<<<<<<<< GOOGLE SIGN IN EXCEPTION : >>>>>>>>>>>>>>>>\n$exception');
      }
    }

    return _userProfile;
  }
}
