import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../pages/PatientInfoPage.dart';
import '../pages/PatientTreatment.dart';
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
        measures
            .addAll(await MeasureApi.getWeights(_settings, _patient.id) ?? []);
        measures.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        _settings.cachedMeasures = measures;
      }
      return _settings.cachedMeasures;
    }
  }

  List<Widget> _populateChildren(List<Measure> measures) {
    List<Widget> retVal = [];

    retVal.add(Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Antecedentes",
                      style: TextStyle(color: Colors.brown, fontSize: 16),
                    )
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                children: this
                    ._patient
                    .indicators
                    .entries
                    .where((e) => e.value == true)
                    .map((e) {
                      return [
                        (e.key == 'erc')
                            ? Text(
                                Patient.indicatorsDescription[e.key] +
                                    " (FG: " +
                                    _patient.indicators['erc_fg'].toString() +
                                    ")",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Text(
                                Patient.indicatorsDescription[e.key],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                        (_patient.indicators.entries
                                    .where((e) => e.value == true)
                                    .last
                                    .key ==
                                e.key)
                            ? Container()
                            : Text(", ")
                      ];
                    })
                    .expand((i) => i)
                    .toList(),
              ),
              _patient.history != null ? Container(height: 8): Container(),
              _patient.history != null ? Align(alignment: Alignment.topLeft, child: Text(_patient.history)): Container(),
              //Divider()
            ])));

    if (_settings.graphsShown)
      retVal.add(Container(
        padding: const EdgeInsets.all(8.0),
        height: 200,
        child: PageView(
          controller: _measuresController,
          children: <Widget>[
            GraphWidget(
              series: _createPressureData(measures),
              title: "Presión Sanguinea",
              position: 1,
              total: 4,
              annotations: (_patient.limit_diastolic != null &&
                      _patient.limit_systolic != null)
                  ? _pressureAnnotations(
                      _patient.limit_systolic, _patient.limit_diastolic)
                  : [],
            ),
            GraphWidget(
              series: _createPulseData(measures),
              title: "Pulso (bpm)",
              position: 2,
              total: 4,
              annotations: (_patient.limit_pulse != null)
                  ? _pulseAnnotation(_patient.limit_pulse.toDouble())
                  : [],
            ),
            GraphWidget(
                series: _createWeightData(measures),
                title: "Peso (kg)",
                position: 3,
                total: 4),
            GraphWidget(
              series: _createImcData(_patient, measures),
              title: "IMC",
              position: 4,
              total: 4,
            ),
          ],
        ),
      ));
    if (_patient.treatment != "" && _patient.treatment != null)
      retVal.add(Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Tratamiento",
                        style: TextStyle(color: Colors.brown, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_patient.treatment),
                      ),
                    ),
                  ],
                ),
                Divider()
              ])));

    retVal.addAll(measures
        .map((e) => MeasureWidget(
              e,
              height: this._patient.height,
            ))
        .toList());

    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    if (_settings.viewingPatient == null) Navigator.of(context).pop();

    _patient = _settings.viewingPatient;
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientInfoPage(edit: true)));
            _settings.refreshUI();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_patient != null
                  ? _patient.name + " " + _patient.lastName
                  : Constants.historics_title),
              (_patient.rythm_type != null)
                  ? Text(Patient.rythmTypes[_patient.rythm_type],
                      style: Theme.of(context).textTheme.body1.copyWith(
                          color: Colors.white, fontStyle: FontStyle.italic))
                  : Container()
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.fileMedicalAlt),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PatientTreatment()));
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
                child: ListView(children: _populateChildren(snapshot.data)),
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

  static List<charts.LineAnnotationSegment> _pressureAnnotations(
      int high, int low) {
    return [
      new charts.LineAnnotationSegment(
          high, charts.RangeAnnotationAxisType.measure,
          startLabel: high.toString() + " mmHg",
          color: charts.MaterialPalette.gray.shade300),
      new charts.LineAnnotationSegment(
          low, charts.RangeAnnotationAxisType.measure,
          startLabel: low.toString() + " mmHg",
          color: charts.MaterialPalette.gray.shade200),
    ];
  }

  static List<charts.LineAnnotationSegment> _weightAnnotation(double value) {
    return [
      new charts.LineAnnotationSegment(
          value, charts.RangeAnnotationAxisType.measure,
          startLabel: 'Objetivo (' + value.toString() + " kg)",
          color: charts.MaterialPalette.gray.shade300)
    ];
  }

  static List<charts.LineAnnotationSegment> _pulseAnnotation(double value) {
    return [
      new charts.LineAnnotationSegment(
          value, charts.RangeAnnotationAxisType.measure,
          startLabel: 'Limite (' + value.toString() + " bpm)",
          color: charts.MaterialPalette.gray.shade300)
    ];
  }

  static List<charts.Series<Preasure, DateTime>> _createPressureData(
      List<Measure> _measures) {
    List<Preasure> data =
        _measures.map((m) => (m is Preasure) ? m : null).toList();
    data.removeWhere((m) => m == null);
    data.removeWhere((m) => m.high == null || m.high == 0);
    data.removeWhere((m) => m.low == null || m.low == 0);

    return [
      new charts.Series<Preasure, DateTime>(
        id: 'Systolic',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Preasure p, _) => p.timestamp,
        measureFn: (Preasure p, _) => p.high,
        data: data,
      ),
      new charts.Series<Preasure, DateTime>(
        id: 'Diastolic',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Preasure p, _) => p.timestamp,
        measureFn: (Preasure p, _) => p.low,
        data: data,
      ),
    ];
  }

  static List<charts.Series<Preasure, DateTime>> _createPulseData(
      List<Measure> _measures) {
    List<Preasure> data =
        _measures.map((m) => (m is Preasure) ? m : null).toList();
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

  static List<charts.Series<Weight, DateTime>> _createWeightData(
      List<Measure> _measures) {
    List<Weight> data = _measures.map((m) => (m is Weight) ? m : null).toList();
    data.removeWhere((m) => m == null);

    return [
      new charts.Series<Weight, DateTime>(
        id: 'Weight',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Weight p, _) => p.timestamp,
        measureFn: (Weight p, _) => p.value,
        data: data,
      )
    ];
  }

  static List<charts.Series<Weight, DateTime>> _createImcData(
      Patient patient, List<Measure> _measures) {
    List<Weight> data = _measures.map((m) => (m is Weight) ? m : null).toList();
    data.removeWhere((m) => m == null);

    return [
      new charts.Series<Weight, DateTime>(
        id: 'IMC',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (Weight p, _) => p.timestamp,
        measureFn: (Weight p, _) => double.parse(
            (p.value / ((patient.height / 100) * (patient.height / 100)))
                .toStringAsFixed(2)),
        data: data,
      )
    ];
  }
}
