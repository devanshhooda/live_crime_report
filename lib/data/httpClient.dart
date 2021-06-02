import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

class HTTPclient {
  final String _baseUrl = 'http://localhost:8000';

  Future getRequest(
      {@required requestUrl, @required Map<String, String> headers}) async {
    String url = _baseUrl + requestUrl;
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future postRequest(
      {@required Map<String, String> body,
      @required requestUrl,
      @required Map<String, String> headers}) async {
    String url = _baseUrl + requestUrl;
    http.Response response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);
    return response.body;
  }
}
