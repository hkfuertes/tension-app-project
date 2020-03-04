import 'dart:async';
import 'dart:convert';

import 'ValidationHelper.dart';
import '../model/Settings.dart';

import '../model/User.dart';
import '../constants.dart' as Constants;

class UserApi{

  static Future<User> getUser(Settings settings) async {
  final response =
      await ValidationHelper.doGet(settings,Constants.baseUrl + '/doctor', 
      headers: {Constants.token_key: "Bearer "+settings.access_token});

  if (response.statusCode == 200) {
    print(response.body);
    // If server returns an OK response, parse the JSON
    return User.fromJson(json.decode(response.body)['data']);
  } else {
    return null;
  }
}

}