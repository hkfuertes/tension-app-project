import 'dart:async';
import 'dart:convert';

import 'ValidationHelper.dart';
import '../model/Patient.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;
import 'package:http/http.dart' as http;

class PatientApi {
  Future<Patient> getPatient(Settings settings, patientId) async {
    final response = await http.get(
        Constants.baseUrl + '/patient/' + patientId,
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      print(response.body);
      // If server returns an OK response, parse the JSON
      return Patient.fromJson(json.decode(response.body)['data']);
    } else {
      return null;
    }
  }

  Future<List<Patient>> getPatients(Settings settings) async {
    final response = await ValidationHelper.doGet(settings, Constants.baseUrl + '/patients',
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body)['data'];
      return data.map((model) => Patient.fromJson(model)).toList();
    } else {
      return null;
    }
  }
}
