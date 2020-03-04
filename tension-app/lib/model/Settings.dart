import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/MeasureModel.dart';

import 'Patient.dart';
import 'User.dart';


class Settings extends ChangeNotifier {
  static const IS_DARK_TOKEN = "isDark";

  static const ACCESS_TOKEN = "access_token";
  static const REFRESH_TOKEN = "refresh_token";

  //Settings
  bool darkTheme = false;
  String access_token = "";
  String refresh_token = "";

  User doctor;

  List<Patient> cachedPatientList;
  List<Measure> cachedMeasures;
  Patient viewingPatient;

  Settings() {
    this.darkTheme = false;
    this.access_token = "";
    this.refresh_token = "";
    this.cachedPatientList = [];
    this.cachedMeasures = [];
  }

  void fill(SharedPreferences sp) {
    this.darkTheme = sp.getBool(IS_DARK_TOKEN);
    this.darkTheme = (this.darkTheme == null) ? false : this.darkTheme;

    this.access_token = sp.getString(ACCESS_TOKEN);
    this.access_token = (this.access_token == null) ? "" : this.access_token;

    this.refresh_token = sp.getString(REFRESH_TOKEN);
    this.refresh_token = (this.refresh_token == null) ? "" : this.refresh_token;

    //notifyListeners();
  }

  void logout(){
    this.darkTheme = false;
    this.access_token = "";
    this.refresh_token = "";
    this.cachedPatientList = [];
    this.cachedMeasures = [];
    this.doctor = null;

    saveSettings().then((_){
      Fluttertoast.showToast(
        msg: "¡Sesión cerrada con éxito!", toastLength: Toast.LENGTH_SHORT);
    });
  }

  void setDoctor(doctor){
    this.doctor = doctor;
  }

  Brightness getBrightness() {
    return (this.darkTheme ?? true) ? Brightness.dark : Brightness.light;
  }


  void setDarkTheme(bool value) {
    this.darkTheme = value;

    saveSettings().then((_) {});
  }

  Future<void> saveSettings({bool toast=true, reloadUi=true}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(IS_DARK_TOKEN, this.darkTheme);
    await sp.setString(ACCESS_TOKEN, this.access_token);
    await sp.setString(REFRESH_TOKEN, this.refresh_token);

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
