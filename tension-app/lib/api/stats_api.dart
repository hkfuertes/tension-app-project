import 'dart:async';
import 'dart:convert';

import 'ValidationHelper.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;

class StatsApi {

  static Future<List<dynamic>> getPressures(Settings settings) async {
    final response = await ValidationHelper.doGet(settings, Constants.baseUrl +'/stats/pressure',
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      return null;
    }
  }

static Future<List<dynamic>> getPulses(Settings settings) async {
    final response = await ValidationHelper.doGet(settings, Constants.baseUrl + '/stats/pulse',
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> getWeights(Settings settings) async {
    final response = await ValidationHelper.doGet(settings, Constants.baseUrl + '/stats/weight',
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> getAll(Settings settings) async {
    final response = await ValidationHelper.doGet(settings, Constants.baseUrl + '/stats',
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      return null;
    }
  }

}
