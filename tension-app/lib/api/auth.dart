import 'dart:async';
import 'dart:convert';

import '../model/AuthorizationModel.dart';
import '../constants.dart' as Constants;
import 'package:http/http.dart' as http;

class Authorization{

  static Future<AuthoritationModel> login(String email, String password) async {
    print(Constants.host + '/auth');
  final response =
      await http.post(Constants.host + '/auth',
      body: json.encode({'username':email.trim(),'password':password.trim()}),
      headers: { "Content-type": "application/json" });

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return AuthoritationModel.fromJson(json.decode(response.body));
  } else {
    return null;
  }
}

static Future<AuthoritationModel> refresh(String refresh) async {
  final response =
      await http.post(Constants.host + '/refresh', headers: {Constants.token_key: "Bearer "+ refresh});

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return AuthoritationModel.fromJson(json.decode(response.body));
  } else {
    return null;
  }
}

}