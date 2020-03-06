import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/auth.dart';
import '../model/AuthorizationModel.dart';

import 'package:provider/provider.dart';
import '../model/Settings.dart';

import '../api/user.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _email = "";
  String _password = "";

  Settings _settings;

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _doLogin() async {
    AuthoritationModel authModel = await Authorization.login(_email, _password);

    if (_settings != null && authModel != null) {
      _settings.access_token = authModel.token;
      _settings.refresh_token = authModel.refresh;

      _settings.setDoctor(await UserApi.getUser(_settings));

      _settings.saveSettings().then((_) {
        print(authModel.token);
      });
    }else{
      Fluttertoast.showToast(msg: "¡Algo salio mal, prueba otra vez!",toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    return new Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, elevation: 0.0,),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            color: Colors.brown,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "TENSION",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Opacity(
                      child: Text(
                        "APP",
                        style: TextStyle(color: Colors.white, fontSize: 35.0),
                      ),
                      opacity: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildTextFields(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          Container(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlineButton(
                  child: new Text('Entrar'),
                  onPressed: _doLogin,
                ),
              ),
            ],
          ),
          Container(
            height: 32,
          )
        ],
      ),
    );
  }
}
