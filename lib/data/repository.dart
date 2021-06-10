import 'package:flutter/widgets.dart';
import 'package:live_crime_report/models/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/userProfile.dart';

class AppRepository {
  SharedPreferences _sharedPreferences;

  AppRepository() {
    _initSharedPreferences();
  }

  Future saveUserToSP({@required UserProfile userProfile}) async {
    bool nameSaved =
        await this._saveStringToSP(value: userProfile.name, key: 'name');
    bool phoneSaved =
        await this._saveStringToSP(value: userProfile.name, key: 'phone');

    print('nameSaved : $nameSaved');
    print('phoneSaved : $phoneSaved');
  }

  Future<UserProfile> getUserFromSP() async {
    String userName = await this.getStringFromSP(key: 'name');
    String phoneNumber = await this.getStringFromSP(key: 'phone');

    return new UserProfile(name: userName, phoneNumber: phoneNumber);
  }

  Future _initSharedPreferences() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
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

  Future<String> getStringFromSP({@required String key}) async {
    _initSharedPreferences(); // for null check
    return _sharedPreferences.getString(key);
  }
}
