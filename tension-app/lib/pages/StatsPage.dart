import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/LoadingWidget.dart';
import '../api/stats_api.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;
import 'package:charts_flutter/flutter.dart' as charts;

class StatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Settings _settings;
  List<Map<String, dynamic>> _stats = [];

  List<String> _medidasNombres = [
    '[Presion, Pulso, Peso] frente a edad',
    '[Presion, Pulso, Peso] frente a genero',
    '[Presion, Pulso, Peso] frente a altura'
  ];

  int _selectedMetric = 0;

  Future<Map<String, dynamic>> _getAllData() async {
    if (_settings != null) {
      return {
        'pressures': await StatsApi.getPressures(_settings),
        'pulses': await StatsApi.getPulses(_settings),
        'weights': await StatsApi.getWeights(_settings)
      };
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(Constants.stats_title),
          leading: Icon(FontAwesomeIcons.book),
        ),
        body: FutureBuilder(
            future: _getAllData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return ListView(
                  children: <Widget>[
                    /*
                    new DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("Métrica"),
                      value: _medidasNombres[_selectedMetric],
                      items: _medidasNombres.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(value)),
                          ),
                        );
                      }).toList(),
                      onChanged: (selected) {
                        setState(() {
                          _selectedMetric = _medidasNombres.indexOf(selected);
                        });
                      },
                    ),
                    */
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                      child: Center(
                        child: Text(
                          "Presión sanguinea",
                          style: TextStyle(fontSize: 20.0, color: Colors.brown),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      height: 250.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white),
                        child: charts.ScatterPlotChart(
                          _createSeriesForPreasures(snapshot.data['pressures']),
                          animate: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                      child: Center(
                        child: Text(
                          "Pulso",
                          style: TextStyle(fontSize: 20.0, color: Colors.brown),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      height: 250.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white),
                        child: charts.ScatterPlotChart(
                          _createSeriesForPulses(snapshot.data['pulses']),
                          animate: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                      child: Center(
                        child: Text(
                          "Peso",
                          style: TextStyle(fontSize: 20.0, color: Colors.brown),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      height: 250.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white),
                        child: charts.ScatterPlotChart(
                          _createSeriesForWeights(snapshot.data['weights']),
                          animate: false,
                        ),
                      ),
                    ),
                    Container(height: 30,)
                  ],
                );
              } else
                return LoadingWidget("Cargando estadisticas ...");
            }));
  }

  // Data for Pressures
  List<charts.Series<dynamic, int>> _createSeriesForPreasures(
      List<dynamic> pressures) {
    return [
      new charts.Series<dynamic, int>(
        id: 'Alta',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (pressure, _) {
          switch (_selectedMetric) {
            case 0:
              return pressure['age'];
            case 1:
              return pressure['gender'];
            case 2:
              return pressure['height'];
            default:
              return pressure['age'];
          }
        },
        measureFn: (pressure, _) => pressure['high'],
        data: pressures,
      ),
      new charts.Series<dynamic, int>(
        id: 'Baja',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (pressure, _) {
          switch (_selectedMetric) {
            default:
              return pressure['age'];
          }
        },
        measureFn: (pressure, _) => pressure['low'],
        data: pressures,
      ),
    ];
  }

  // Data for Pulses
  static List<charts.Series<dynamic, int>> _createSeriesForPulses(
      List<dynamic> pulses) {
    return [
      new charts.Series<dynamic, int>(
        id: 'Pulso',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (pulse, _) => pulse['age'],
        measureFn: (pulse, _) => pulse['pulse'],
        data: pulses,
      ),
    ];
  }

  // Data for Weights
  static List<charts.Series<dynamic, int>> _createSeriesForWeights(
      List<dynamic> weights) {
    return [
      new charts.Series<dynamic, int>(
        id: 'Peso',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (weight, _) => weight['age'],
        measureFn: (weight, _) => weight['weight'],
        data: weights,
      ),
    ];
  }
}
