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

import 'package:charts_flutter/flutter.dart' as charts;

import 'GraphWidget.dart';


class HistoricPage extends StatelessWidget {
  static String tag = 'historic-page';

  List<Measure> measures = List<Measure>();

  Settings _settings;

  Patient _patient;

  final _measuresController = PageController(initialPage: 0);

  Future<dynamic> _getAllData({force: true}) async {
    if (_settings != null) {
      if (_settings.cachedMeasures.length == 0 || force) {
        List<Measure> measures = [];
        measures.addAll(
            await MeasureApi.getPressures(_settings, _patient.id) ?? []);
        measures.addAll(
            await MeasureApi.getWeights(_settings, _patient.id) ?? []);
        measures.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        _settings.cachedMeasures = measures;
      }
      return _settings.cachedMeasures;
    }
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    if(_settings.viewingPatient == null) Navigator.of(context).pop();

    _patient = _settings.viewingPatient;
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
      body: FutureBuilder(
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
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (BuildContext context, int position) {
                      if (position == 0)
                        return !_settings.graphsShown ? Container() :Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 200,
                          child: PageView(
                            controller: _measuresController,
                            children: <Widget>[
                              GraphWidget(series: _createPressureData(snapshot.data), title: "Presión Sanguinea", position: 1, total:3),
                              GraphWidget(series: _createPulseData(snapshot.data), title: "Pulso (bpm)",position: 2, total:3),
                              GraphWidget(series: _createWeightData(snapshot.data), title: "Peso (kg)",position: 3, total:3),
                            ],
                          ),
                        );
                      else
                        return MeasureWidget(snapshot.data[position-1]);
                    }),
              );
            } else
              return LoadingWidget("Cargando mediciones...");
          }),
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
                  onPressed: () async {
                    await showDialog(
                        context: context, child: WeightInputDialog.getDialog());
                    _settings.refreshUI();
                  })
            ],
          ),
        ),
      ),
    );
  }

  static List<charts.Series<Preasure, DateTime>> _createPressureData(List<Measure> _measures) {

    List<Preasure> data = _measures.map((m) => (m is Preasure)? m : null).toList();
    data.removeWhere((m) => m == null);
    data.removeWhere((m) => m.high == null || m.high == 0);
    data.removeWhere((m) => m.low == null || m.low == 0);

    return [
      new charts.Series<Preasure, DateTime>(
        id: 'High',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Preasure p, _) => p.timestamp,
        measureFn: (Preasure p, _) => p.high,
        data: data,
      ),
      new charts.Series<Preasure, DateTime>(
        id: 'Low',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Preasure p, _) => p.timestamp,
        measureFn: (Preasure p, _) => p.low,
        data: data,
      )
    ];
  }

  static List<charts.Series<Preasure, DateTime>> _createPulseData(List<Measure> _measures) {

    List<Preasure> data = _measures.map((m) => (m is Preasure)? m : null).toList();
    data.removeWhere((m) => m == null);

    return [
      new charts.Series<Preasure, DateTime>(
        id: 'Pulse',
        colorFn: (_, __) => charts.MaterialPalette.black,
        domainFn: (Preasure p, _) => p.timestamp,
        measureFn: (Preasure p, _) => p.low,
        data: data,
      )
    ];
  }

  static List<charts.Series<Weight, DateTime>> _createWeightData(List<Measure> _measures) {

    List<Weight> data = _measures.map((m) => (m is Weight)? m : null).toList();
    data.removeWhere((m) => m == null);

    return [
      new charts.Series<Weight, DateTime>(
        id: 'Pulse',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Weight p, _) => p.timestamp,
        measureFn: (Weight p, _) => p.value,
        data: data,
      )
    ];
  }

}