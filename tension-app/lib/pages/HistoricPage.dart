import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tension_app/pages/PatientInfoPage.dart';
import 'PressureInputPage.dart';
import 'PulseInputPage.dart';
import 'WeightInputDialog.dart';
import '../widgets/LoadingWidget.dart';
import '../widgets/MeasureWidget.dart';
import '../api/measure.dart';
import '../model/Patient.dart';
import '../model/Settings.dart';
import '../model/MeasureModel.dart';
import '../constants.dart' as Constants;

class HistoricPage extends StatelessWidget {
  static String tag = 'historic-page';

  HistoricPage(this._patient);

  List<Measure> measures = List<Measure>();

  Settings _settings;
  Patient _patient;

/*
  _showAddModal(BuildContext context) {
    showModalBottomSheet<void>(
        context: context, builder: HistoricPageWidgets.modalSheet);
  }
*/

  Future<dynamic> _getAllData({force: true}) async {
    if (_settings != null) {
      if (_settings.cachedMeasures.length == 0 || force) {
        List<Measure> measures = [];
        measures.addAll(
            await MeasureApi().getPressures(_settings, _patient.id) ?? []);
        measures.addAll(
            await MeasureApi().getWeights(_settings, _patient.id) ?? []);
        measures.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        _settings.cachedMeasures = measures;
      }
      return _settings.cachedMeasures;
    }
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    _settings.viewingPatient = _patient;
    return Scaffold(
      appBar: AppBar(
        title: Text(_patient != null
            ? _patient.name + " " + _patient.lastName
            : Constants.historics_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async{
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PatientInfoPage(edit: true)));
              _settings.refreshUI();
            },
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async{
          _settings.viewingPatient = null;
          _settings.refreshUI();
          return true;
        },
        child: FutureBuilder(
            future: _getAllData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return RefreshIndicator(
                  //Indeed we just need to repaint.
                  onRefresh: () {
                    _getAllData(force: true);
                    _settings.refreshUI();
                    return Future<void>(() {});
                  },
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int position) {
                        return MeasureWidget(snapshot.data[position]);
                      }),
                );
              } else
                return LoadingWidget("Cargando mediciones...");
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PulseInputPage()));
          },
          tooltip: 'Medir',
          icon: Icon(
            Icons.add,
          ),
          label: Text("Pulso")),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(FontAwesomeIcons.heartbeat, color: Colors.brown),
                label: Text("Tensión"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PressureInputPage()));
                },
              ),
              FlatButton.icon(
                  icon: Icon(FontAwesomeIcons.weight, color: Colors.brown),
                  label: Text("Peso"),
                  onPressed: () {
                    showDialog(
                        context: context, child: WeightInputDialog.getDialog());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
