import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Settings.dart';
import '../constants.dart' as Constants;

class SettingsPage extends StatelessWidget {
  Settings _settings;

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(title: Text(Constants.settings_title),),
      body: ListView(
        children: <Widget>[
          Container(height: 8.0,),
          ListTile(
            leading: Icon(Icons.multiline_chart),
            trailing: Switch(
                activeColor: Colors.white,
                activeTrackColor: Theme.of(context).primaryColorLight,
                onChanged: (value) async {
                  _settings?.graphsShown = value;
                  await _settings?.saveSettings();
                },
                value: _settings.graphsShown ?? false),
            title:  Text(Constants.patient_graph_title),
            subtitle: Text(Constants.patient_graph_text),
            onTap: () async {
              _settings.graphsShown = !_settings.graphsShown;
              await _settings?.saveSettings();
            },
          ),
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
