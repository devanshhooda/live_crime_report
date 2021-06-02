import 'package:flutter/widgets.dart';
import 'package:live_crime_report/data/httpClient.dart';
import 'package:live_crime_report/models/userProfile.dart';

class AppRepository {
  HTTPclient _httPclient;

  AppRepository() {
    _httPclient = new HTTPclient();
  }

  Future<bool> signUp({@required UserProfile profile}) async {
    Map<String, String> body = profile.toJson();

    var responseData = await _httPclient.postRequest(
        body: body, requestUrl: '/signUp', headers: <String, String>{});

    return responseData['status'];
  }

  Future<UserProfile> login() async {
    String token = '';

    var responseData = await _httPclient.getRequest(
        requestUrl: '/login',
        headers: <String, String>{'Authorization': 'jwt  + $token'});

    return UserProfile.fromJson(jsonMap: responseData);
  }
}
