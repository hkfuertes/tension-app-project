import 'dart:async';
import 'dart:convert';

import 'ValidationHelper.dart';
import '../model/Patient.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;
import 'package:http/http.dart' as http;

class PatientApi {
  static Future<Patient> getPatient(Settings settings, patientId) async {
    final response = await http.get(Constants.baseUrl + '/patient/' + patientId,
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      print(response.body);
      // If server returns an OK response, parse the JSON
      return Patient.fromJson(json.decode(response.body)['data']);
    } else {
      return null;
    }
  }

  static Future<List<Patient>> getPatients(Settings settings) async {
    final response = await ValidationHelper.doGet(
        settings, Constants.baseUrl + '/patients',
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body)['data'];
      return data.map((model) => Patient.fromJson(model)).toList();
    } else {
      return null;
    }
  }

  static Future<Patient> postViewingPatient(Settings settings) =>
      postPatient(settings, settings.viewingPatient);

  static Future<Patient> postPatient(Settings settings, Patient patient) async {
    final response = await ValidationHelper.doPost(
        settings, Constants.baseUrl + '/patient',
        headers: {
          Constants.token_key: "Bearer " + settings.access_token
        },
        body: {
          "name": patient.name,
          "lastName": patient.lastName,
          "email": patient.name.toLowerCase()+"@"+patient.lastName.toLowerCase(),
          "password": patient.name.toLowerCase()+"_"+patient.lastName.toLowerCase(),
          "gender": patient.gender,
          "birthday": patient.birthDay.day.toString().padLeft(2, "0") +
              "-" +
              patient.birthDay.month.toString().padLeft(2, "0") +
              "-" +
              patient.birthDay.year.toString(),
          "height": patient.height.toString()
        });

    print(response.body);
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return Patient.fromJson(json.decode(response.body)['data']);
    } else {
      return null;
    }
  }

  static Future<Patient> putViewingPatient(Settings settings) =>
      putPatient(settings, settings.viewingPatient);

  static Future<Patient> putPatient(Settings settings, Patient patient) async {
    final response = await ValidationHelper.doPut(
        settings, Constants.baseUrl + '/patient/' + patient.id.toString(),
        headers: {
          Constants.token_key: "Bearer " + settings.access_token
        },
        body: {
          "name": patient.name,
          "lastName": patient.lastName,
          "gender": patient.gender,
          "birthday": patient.birthDay.year.toString() +
              "-" +
              patient.birthDay.month.toString().padLeft(2, "0") +
              "-" +
              patient.birthDay.day.toString().padLeft(2, "0"),
          "height": patient.height.toString(),
          "limit_systolic": patient.limit_systolic.toString(),
          "limit_diastolic": patient.limit_diastolic.toString(),
          "limit_pulse": patient.limit_pulse.toString(),
          "rythm_type": patient.rythm_type.toString(),
          "treatment": patient.treatment
        });

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return Patient.fromJson(json.decode(response.body)['data']);
    } else {
      return null;
    }
  }

  static Future<bool> deleteViewingPatient(Settings settings) =>
      deletePatient(settings, settings.viewingPatient);

  static Future<bool> deletePatient(Settings settings, Patient patient) async {
    final response = await ValidationHelper.doDelete(
        settings, Constants.baseUrl + '/patient/' + patient.id.toString(),
        headers: {Constants.token_key: "Bearer " + settings.access_token});

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body)['result'] == 'success';
    } else {
      return null;
    }
  }
}
