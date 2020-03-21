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
  static const WEIGHT_OBJ = "weight_obj";
  static const TARGET_ON = "target_on";
  static const ARDUINO_ON = "arduino_on";

  //Settings
  String access_token = "";
  String refresh_token = "";

  User doctor;

  List<Patient> cachedPatientList;
  List<Measure> cachedMeasures;
  Patient viewingPatient;

  bool graphsShown = true;

  bool objetivo = false;
  double objetivoPeso = -1;

  bool deviceEnable = false;

  Settings() {
    this.access_token = "";
    this.refresh_token = "";
    this.cachedPatientList = [];
    this.cachedMeasures = [];
    this.graphsShown = true;
    this.objetivoPeso = -1;
    this.objetivo = false;
    this.deviceEnable = true;
  }

  void fill(SharedPreferences sp) {

    this.access_token = sp.getString(ACCESS_TOKEN);
    this.access_token = (this.access_token == null) ? "" : this.access_token;

    this.refresh_token = sp.getString(REFRESH_TOKEN);
    this.refresh_token = (this.refresh_token == null) ? "" : this.refresh_token;

    this.graphsShown = sp.getBool(GRAPH_SHOWN);
    this.graphsShown = (this.graphsShown == null) ? true : this.graphsShown;

    this.objetivo = sp.getBool(TARGET_ON);
    this.objetivo = (this.objetivo == null) ? false : this.objetivo;

    this.objetivoPeso = sp.getDouble(WEIGHT_OBJ);
    this.objetivoPeso = (this.objetivoPeso == null) ? 0 : this.objetivoPeso;

    this.deviceEnable = sp.getBool(ARDUINO_ON);
    this.deviceEnable = (this.deviceEnable == null) ? true : this.deviceEnable;

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
    await sp.setDouble(WEIGHT_OBJ, this.objetivoPeso);
    await sp.setBool(TARGET_ON, this.objetivo);
    await sp.setBool(ARDUINO_ON, this.deviceEnable);

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
