import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../model/Settings.dart';
import '../constants.dart' as Constants;

class SettingsPage extends StatelessWidget {
  Settings _settings;

  var _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.settings_title),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 8.0,
          ),
          ListTile(
            leading: Icon(Icons.multiline_chart),
            trailing: Switch(
                onChanged: (value) async {
                  _settings?.graphsShown = value;
                  await _settings?.saveSettings();
                },
                value: _settings.graphsShown ?? false),
            title: Text(Constants.patient_graph_title),
            subtitle: Text(Constants.patient_graph_text),
            onTap: () async {
              _settings.graphsShown = !_settings.graphsShown;
              await _settings?.saveSettings(toast: false);
            },
          ),
          /*
          Container(
            height: 8.0,
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.weight),
            trailing: Switch(
                onChanged: (value) async {
                  _settings?.objetivo = value;
                  await _settings?.saveSettings();
                },
                value: _settings.objetivo ?? false),
            title: Text(Constants.patient_weight_obj_title),
            subtitle: Text(Constants.patient_weight_obj_text),
            onTap: () async {
              _settings.objetivo = !_settings.objetivo;
              await _settings?.saveSettings(toast: false);
            },
          ),
          Container(
            height: 8.0,
          ),
          ListTile(
            enabled: _settings.objetivo,
            leading: Icon(FontAwesomeIcons.bullseye),
            title: Text(Constants.patient_weight_obj_value_title),
            subtitle: Text((_settings.objetivo) &&
                    (_settings.objetivoPeso != -1)
                ? Constants.patient_weight_obj_value_text_selected.replaceAll(
                    Settings.WEIGHT_OBJ, _settings.objetivoPeso.toString())
                : Constants.patient_weight_obj_value_text),
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(Constants.patient_weight_obj_title),
                        content: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              suffixText: "Kg",
                              labelText: "Peso",
                              border: OutlineInputBorder()),
                          controller: _weightController,
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(Constants.save_button),
                            onPressed: () async {
                              _settings.objetivoPeso =
                                  double.parse(_weightController.text);
                                  print(double.parse(_weightController.text));
                              await _settings?.saveSettings(toast: false);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
            },
          ),
          */
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(Constants.log_out_title),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: <Widget>[
                      FlatButton(
                        child: Text(Constants.yes),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _settings.logout();
                        },
                      ),
                      FlatButton(
                        child: Text(Constants.no),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    content: Text(Constants.log_out_text),
                    title: Text(Constants.log_out_title),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
