import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'auth.dart';
import '../model/AuthorizationModel.dart';
import '../model/Settings.dart';
import '../constants.dart' as Constants;

class ValidationHelper {
  static void refreshToken(Settings settings) async {
    if (settings.refresh_token != "") {
      AuthoritationModel authModel =
          await Authorization.refresh(settings.refresh_token);

      if (settings != null && authModel != null) {
        settings.access_token = authModel.token;

        settings.saveSettings(toast: true, reloadUi: false).then((_) {
          print(authModel.token);
        });
      }
    }
  }

  static Future<Response> doPost(Settings settings, url,{Map<String, String> headers, body, Encoding encoding}) async {
    var response = await http.post(url, headers: headers, body: body, encoding: encoding);

    if (response.statusCode == 401) {
      await refreshToken(settings);
      headers[Constants.token_key] = "Bearer " + settings.access_token;
      return await http.post(url, headers: headers, body: body, encoding: encoding);
    }else
      return response;
  }

  static Future<Response> doGet(Settings settings, url,{Map<String, String> headers}) async {
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 401) {
      await refreshToken(settings);
      headers[Constants.token_key] = "Bearer " + settings.access_token;
      return await http.get(url, headers: headers);
    }else
      return response;
  }
}
