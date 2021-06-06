import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:live_crime_report/models/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'googleAuth.dart';
import 'httpClient.dart';

class AppRepository {
  HTTPclient _httPclient;
  GoogleAuth _googleAuth;
  SharedPreferences _sharedPreferences;
  FirebaseMessaging _firebaseMessaging;

  AppRepository() {
    _httPclient = new HTTPclient();
    _googleAuth = new GoogleAuth();
    _firebaseMessaging = FirebaseMessaging.instance;
    _initSharedPreferences();
  }

  _notificationPipeline() {
    FirebaseMessaging.onMessage.listen((event) {});
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onBackgroundMessage((message) => null);
  }

  Future<UserProfile> userLogin() async {
    UserProfile _userProfile = await _googleAuth.signInWithGoogle();

    if (_userProfile == null) {
      print('User NOT logged in by GOOGLE !');
      return null;
    }

    // await _saveFcmTokenToSP();

    // Map<String, String> body = _userProfile.toJson();

    // String _tokenKey = 'fcmToken';
    // String _fcmToken = await this._getStringFromSP(key: _tokenKey);
    // body[_tokenKey] = _fcmToken;

    // var responseData = await _httPclient.postRequest(
    //     body: body, requestUrl: '/userLogin', headers: <String, String>{});

    // print('User LOGIN response (from server) : $responseData');

    // // for signup
    // if (responseData['status'] == false) {
    //   print('.. User LOGIN failed .. trying SIGNUP .. ');

    //   responseData = await this._userSignUp(body: body);

    //   print('User SIGNUP response (from server) : $responseData');

    //   if (responseData['status'] == false) {
    //     print('.. User SIGNUP is also failed ..');
    //     return null;
    //   } else {
    //     print('.. User SIGNUP SUCCESS ..');
    //   }
    // } else {
    //   print('.. User SIGNUP LOGIN ..');
    // }

    // _userProfile = UserProfile.fromJSON(jsonMap: responseData);

    // await _saveUserAndGoogleIdToSP(
    //     userId: _userProfile.userId, googleId: _userProfile.googleId);

    return _userProfile;
  }

  Future _userSignUp({@required var body}) async {
    return await _httPclient.postRequest(
        body: body, requestUrl: '/signUp', headers: <String, String>{});
  }

  // ALL SHAREDPREFERENCES WORK IS DONE BELOW

  Future _initSharedPreferences() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future _saveUserAndGoogleIdToSP(
      {@required String userId, @required String googleId}) async {
    print('userId : $userId');
    print('googleId : $googleId');

    bool uidSaved = await this._saveStringToSP(value: userId, key: 'userId');
    bool gidSaved =
        await this._saveStringToSP(value: googleId, key: 'googleId');

    print('uidSaved? : $uidSaved');
    print('googleId? : $gidSaved');
  }

  Future _saveFcmTokenToSP() async {
    String fcmToken = await _firebaseMessaging.getToken();

    bool savedToSp =
        await this._saveStringToSP(value: fcmToken, key: 'fcmToken');

    if (savedToSp) {
      print('FCM token saved to SP successfully and fcmToken : $fcmToken');
    } else {
      print('FCM token saving ERROR in SP');
    }
  }

  Future<bool> _saveStringToSP({@required String value, @required key}) async {
    _initSharedPreferences(); // for null check
    try {
      await _sharedPreferences.setString(key, value);
      return true;
    } catch (e) {
      print('_saveStringToSP exception : $e');
      return false;
    }
  }

  Future<String> _getStringFromSP({@required String key}) async {
    _initSharedPreferences(); // for null check
    return _sharedPreferences.getString(key);
  }
}
