import 'dart:async';
import 'dart:convert';

import 'ValidationHelper.dart';
import '../model/Settings.dart';

import '../model/MeasureModel.dart';
import '../constants.dart' as Constants;

class MeasureApi {
  static Future<List<Preasure>> getPressures(Settings settings, patient_id) async {
    final response = await ValidationHelper.doGet(
        settings, Constants.baseUrl + '/patient/' + patient_id + '/pressure',
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body)['data'];
      return data.map((model) => Preasure.fromJson(model)).toList();
    } else {
      return null;
    }
  }

  static Future<List<Weight>> getWeights(Settings settings, patient_id) async {
    final response = await ValidationHelper.doGet(
        settings, Constants.baseUrl + '/patient/' + patient_id + '/weight',
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body)['data'];
      return data.map((model) => Weight.fromJson(model)).toList();
    } else {
      return null;
    }
  }

  static Future<bool> postWeight(Settings settings, patientId, Weight weight) async {
    final response = await ValidationHelper.doPost(
        settings, Constants.baseUrl + '/patient/'+patientId+'/weight', body: {
      'timestamp': weight.timestamp.toString(),
      'weight': weight.value.toString()
    }, headers: {
      Constants.token_key: "Bearer " + settings.access_token
    });

    return (response.statusCode == 200);
  }

  static Future<bool> postPreasure(
      Settings settings, patientId, Preasure pressure) async {
    final response = await ValidationHelper.doPost(
        settings,
        Uri.encodeFull(Constants.baseUrl +
            "/patient/" +
            patientId.toString() +
            "/pressure"),
        encoding: Encoding.getByName("utf-8"),
        headers: {
          Constants.token_key: "Bearer " + settings.access_token
        },
        body: {
          'timestamp': DateTime.now().toString(),
          'high': pressure.high.toString(),
          'low': pressure.low.toString(),
          'pulse': pressure.pulse.toString(),
        });

    return (response.statusCode == 200);
  }
}
