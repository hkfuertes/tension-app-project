import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;

class ProfilePage extends StatelessWidget {
  Settings _settings;
  double _spacing = 20.0;
  static const double _padding = 16.0;

  TextEditingController _nombre = TextEditingController(),
      _appellido = TextEditingController();

  TextEditingController _contrasena = TextEditingController(),
      _rcontrasena = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    _nombre.text = _settings.doctor.name;
    _appellido.text = _settings.doctor.lastName;

    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.profile_title),
        leading: Icon(FontAwesomeIcons.userMd),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: <Widget>[
                      FlatButton(
                        child: Text(Constants.log_out_button),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _settings.logout();
                        },
                      )
                    ],
                    content: Text(Constants.log_out_text),
                    title: Text(Constants.log_out_title),
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 2 * _spacing,
          ),
          SizedBox(
            height: 100.0,
            width: 100.0,
            child: CircleAvatar(
              child: Icon(
                FontAwesomeIcons.userMd,
                size: 55.0,
              ),
            ),
          ),
          Container(
            height: 2 * _spacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:_padding),
            child: TextField(
              controller: _nombre,
              autofocus: false,
              decoration: InputDecoration(
                  labelText: "Nombre", border: OutlineInputBorder()),
            ),
          ),
          Container(
            height: _spacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:_padding),
            child: TextField(
              controller: _appellido,
              autofocus: false,
              decoration: InputDecoration(
                  labelText: "Appelido", border: OutlineInputBorder()),
            ),
          ),
          Container(
            height: _spacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:_padding),
            child: TextField(
              controller: _contrasena,
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                  labelText: "Contraseña", border: OutlineInputBorder()),
            ),
          ),
          Container(
            height: _spacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:_padding),
            child: TextField(
              controller: _rcontrasena,
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                  labelText: "Repetir contraseña",
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: OutlineButton(
              child: Text("Guardar"),
              onPressed: () async {},
            ),
          )
        ],
      ),
    );
  }
}
