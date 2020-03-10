import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/MeasureModel.dart';

import 'Patient.dart';
import 'User.dart';


class Settings extends ChangeNotifier {

  static const ACCESS_TOKEN = "access_token";
  static const REFRESH_TOKEN = "refresh_token";
  static const GRAPH_SHOWN = "graph_shown";

  //Settings
  String access_token = "";
  String refresh_token = "";

  User doctor;

  List<Patient> cachedPatientList;
  List<Measure> cachedMeasures;
  Patient viewingPatient;

  bool graphsShown = true;

  Settings() {
    this.access_token = "";
    this.refresh_token = "";
    this.cachedPatientList = [];
    this.cachedMeasures = [];
  }

  void fill(SharedPreferences sp) {

    this.access_token = sp.getString(ACCESS_TOKEN);
    this.access_token = (this.access_token == null) ? "" : this.access_token;

    this.refresh_token = sp.getString(REFRESH_TOKEN);
    this.refresh_token = (this.refresh_token == null) ? "" : this.refresh_token;

    this.graphsShown = sp.getBool(GRAPH_SHOWN);
    this.graphsShown = (this.graphsShown == null) ? true : this.graphsShown;

    //notifyListeners();
  }

  void updateCahedPatientWithViewingPatient(){
    var index = cachedPatientList.indexOf(this.viewingPatient);
    this.cachedPatientList[index] = this.viewingPatient;
    this.refreshUI();
  }

  void logout(){
    this.access_token = "";
    this.refresh_token = "";
    this.cachedPatientList = [];
    this.cachedMeasures = [];
    this.doctor = null;
    this.graphsShown = true;

    saveSettings().then((_){
      Fluttertoast.showToast(
        msg: "¡Sesión cerrada con éxito!", toastLength: Toast.LENGTH_SHORT);
    });
  }

  void setDoctor(doctor){
    this.doctor = doctor;
  }

  Future<void> saveSettings({bool toast=true, reloadUi=true}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(ACCESS_TOKEN, this.access_token);
    await sp.setString(REFRESH_TOKEN, this.refresh_token);
    await sp.setBool(GRAPH_SHOWN, this.graphsShown);

    if(toast)
      Fluttertoast.showToast(
        msg: "¡Ajustes guardados!", toastLength: Toast.LENGTH_SHORT);
    
    if(reloadUi)
      this.refreshUI();

  }

  void refreshUI(){
    notifyListeners();
  }

}
