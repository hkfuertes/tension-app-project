import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tension_app/pages/PatientInfoPage.dart';
import '../api/patient.dart';
import '../widgets/LoadingWidget.dart';
import '../widgets/PatientListTile.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;

import 'HistoricPage.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  final String PATIENT_LIST_KEY = "patient_list_key";

  Settings _settings;

  Future<dynamic> _getAllData({force = false}) async {
    if (_settings != null) {
      if (_settings.cachedPatientList.length == 0 || force) {
        _settings.cachedPatientList = await PatientApi().getPatients(_settings);
      }
      return _settings.cachedPatientList;
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.patients_title),
        // TODO: Change with image
        leading: Icon(FontAwesomeIcons.fileMedicalAlt),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PatientInfoPage()));
            },
          ),
        ],
      ),
      /*
        drawer: Drawer(
          child: HomePageWidgets.drawer(context, _settings.doctor),
        ),
        */

      body: FutureBuilder(
          future: _getAllData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return RefreshIndicator(
                //Indeed we just need to repaint.
                onRefresh: () async {
                  await _getAllData(force: true);
                  _settings.refreshUI();
                  return;
                },
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int position) {
                      return PatientListTile(
                          patient: snapshot.data[position],
                          onTap: (patient) {
                            _settings.viewingPatient = patient;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HistoricPage(patient)));
                          });
                    }),
              );
            } else
              return LoadingWidget("Cargando pacientes ...");
          }),
    );
  }
}
