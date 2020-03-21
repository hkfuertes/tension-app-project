import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../api/measure.dart';
import '../model/MeasureModel.dart';
import '../model/Settings.dart';

import 'dart:core';
import 'dart:io' show Platform;

class PulseInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PulseInputPageState();
  }
}

class _PulseInputPageState extends State<PulseInputPage> {
  MethodChannel _platform =
      const MethodChannel('net.mfuertes.tensionapp/channel');

  Settings _settings;
  int _beats = 0;

  TextEditingController _controller = TextEditingController();

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    //_controller.text = _beats.toString();

    return Scaffold(
        appBar: AppBar(
            title: Text("Medición de Pulso"),
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
                  _beats = int.parse(_controller.text);
                  var measure = Preasure(pulse: _beats);
                  MeasureApi
                      .postPreasure(
                          _settings, _settings.viewingPatient.id, measure)
                      .then((_) {
                    _settings.cachedMeasures.add(measure);
                    Navigator.of(context).pop();
                  });
                },
              ),
            ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              shadowColor: Colors.brown,
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: new TextStyle(fontSize: 24, color: Colors.black),
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  decoration: InputDecoration(
                      suffixText: "bpm",
                      labelText: "Pulso",
                      border: OutlineInputBorder()),
                )),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    enabled: Platform.isAndroid,
                    title: Text("Medir con el Móvil"),
                    subtitle: Text("Usar el flash del móvil y la camara."),
                    onTap: () {
                      _startCameraActivity();
                    },
                  ),
                  ListTile(
                    enabled: Platform.isAndroid && _settings.deviceEnable,
                    title: Text("Medir con el aparato"),
                    subtitle:
                        Text("Conectar el aparato al puerto USB para medir."),
                    onTap: () async {
                      _startSerialActivity();
                      /*
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PulseInputUSBPage()));
                      setState(() {
                        _beats = result != null && (result.containsKey('pulse') ) ? result['pulse'] : _beats;
                        _controller.text = _beats.toString();
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _beats.toString().length));
                      });
                       */
                    },
                  ),
                  ListTile(
                    title: Text("Introducir manualmente"),
                    subtitle: Text("Copiar el dato de un medidor externo."),
                    onTap: () {
                      FocusScope.of(context).requestFocus(_focusNode);
                    },
                  )
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.brown,
          height: 2,
        ));
  }

  Future<void> _startCameraActivity() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    if ([PermissionStatus.unknown]
        .contains(permissions[PermissionGroup.camera])) {
      await PermissionHandler()
          .shouldShowRequestPermissionRationale(PermissionGroup.camera);
      permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.camera]);
    }

    if ([
      PermissionStatus.denied,
      PermissionStatus.disabled,
      PermissionStatus.neverAskAgain
    ].contains(permissions[PermissionGroup.camera])) {
      Fluttertoast.showToast(
          msg: "¡No tengo permiso para usar la camara!",
          toastLength: Toast.LENGTH_LONG);
      return;
    }

    try {
      final int result = await _platform.invokeMethod('startPulseActivity');
      setState(() {
        _beats = result;
        _controller.text = result.toString();
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: result.toString().length));
      });
      debugPrint('Result: $result ');
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
    }
  }

  Future<void> _startSerialActivity() async {
    try {
      final int result = await _platform.invokeMethod('startSerialActivity');
      setState(() {
        _beats = result;
        _controller.text = result.toString();
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: result.toString().length));
      });
      debugPrint('Result: $result ');
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
    }
  }
}
