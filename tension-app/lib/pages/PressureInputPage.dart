import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/measure.dart';
import '../widgets/PressureInputPageWidgets.dart';
import '../model/Settings.dart';
import '../model/MeasureModel.dart';

import 'dart:core';

class PressureInputPage extends StatefulWidget {
  static String tag = 'input-preasure';

  @override
  State<StatefulWidget> createState() {
    return new _PressureInputPageState();
  }
}

class _PressureInputPageState extends State<PressureInputPage> {
  TakeWidget _take = TakeWidget();
  Settings _settings;
  List<Preasure> _pressures = [];
  bool _saved = false;

  _doPost(Preasure pressure) async {
    await MeasureApi().postPreasure(_settings, _settings.viewingPatient.id, pressure);
    _settings.cachedMeasures.add(pressure);
  }

  void _showMessage() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Toma"),
          content: _take,
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  setState(() {
                    _pressures.add(_take.getValues());
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'))
          ],
        );
      },
    );
  }

  void _saveMessage() {
    var avgPressure = _pressures.reduce((value, element) => Preasure(
        high: value.high + element.high,
        low: value.low + element.low,
        pulse: value.pulse + element.pulse));

    avgPressure = Preasure(
      high: (avgPressure.high / _pressures.length).round(),
      low: (avgPressure.low / _pressures.length).round(),
      pulse: (avgPressure.pulse / _pressures.length).round(),
    );

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(8.0),
          title: Text("Enviar"),
          content: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                title: Text("Media de las medidas"),
                subtitle: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                      TextSpan(
                        text: "Alta: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: avgPressure.high.toString()),
                      TextSpan(text: "  "),
                      TextSpan(
                        text: "Baja: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: avgPressure.low.toString()),
                      TextSpan(text: "  "),
                      TextSpan(
                        text: "Pulso: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: avgPressure.pulse.toString()),
                    ])),
                onTap: () async {
                  await _doPost(avgPressure);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Última medida"),
                subtitle: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                      TextSpan(
                        text: "Alta: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: _pressures.last.high.toString()),
                      TextSpan(text: "  "),
                      TextSpan(
                        text: "Baja: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: _pressures.last.low.toString()),
                      TextSpan(text: "  "),
                      TextSpan(
                        text: "Pulso: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: _pressures.last.pulse.toString()),
                    ])),
                onTap: () async {
                  await _doPost(_pressures.last);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text("Introduce la Medición"),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (_pressures.length > 1)
                  _saveMessage();
                else if (_pressures.length > 0){
                  _doPost(_pressures.last);
                  Navigator.of(context).pop();
                } 
                //print(takes.toList().toString());
                //_postTakes(takes);
              },
            ),
          ]),
      body: ListView.builder(
          itemCount: _pressures == null ? 0 : _pressures.length,
          itemBuilder: (BuildContext context, int position) {
            return TakeViewWidget(
              _pressures[position],
              number: position + 1,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMessage();
        },
        tooltip: 'Medir',
        child: Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.brown,
        height: 2,
      ),
    );
  }
}
