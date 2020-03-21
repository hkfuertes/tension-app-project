import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/LoadingWidget.dart';
import '../api/stats_api.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;
import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:io';

class StatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Settings _settings;
  List<Map<String, dynamic>> _stats = [];

  Future<String> get _localTempPath async {
    final directory = await getExternalStorageDirectory();

    return directory.path;
  }

  Future<File> get _tempFile async {
    final path = await _localTempPath;
    return File('$path/stats.csv');
  }

  Widget _processingDialog() {
    return new AlertDialog(
        content: Row(
      children: <Widget>[
        Container(height: 32, width: 32, child: CircularProgressIndicator()),
        Container(
          width: 16,
          height: 1,
        ),
        Text("Descargando datos ...")
      ],
    ));
  }

  Future<File> _downloadAndShare() async {
    List<dynamic> data = await StatsApi.getAll(_settings);
    String allText = (data[0] as Map<String, dynamic>)
            .entries
            .map((e) => '"' + e.key + '"')
            .join(',') +
        "\n";
    File file = await _tempFile;
    for (Map<String, dynamic> el in data) {
      allText +=
          el.entries.map((e) => '"' + e.value.toString() + '"').join(',') +
              "\n";
    }
    return file.writeAsString(allText);
  }

  Widget _downloadAndShareDialog() {
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Compartir"),
          onPressed: () async {
            Navigator.of(context).pop();
            _downloadAndShare().then((File file) async {
              Navigator.of(context).pop();
              await FlutterShare.shareFile(
                title: 'Estadisticas',
                text: 'stats.csv',
                filePath: file.path,
              );
            });
            showDialog(
                context: context, builder: (context) => _processingDialog());
          },
        )
      ],
      content: Text("¿Descargar y compartir estadisticas?",
          style: TextStyle(fontSize: 16)),
      title: Text("Compartir estadisticas"),
    );
  }

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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _downloadAndShareDialog());
              },
            )
          ],
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
                    Container(
                      height: 30,
                    )
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
