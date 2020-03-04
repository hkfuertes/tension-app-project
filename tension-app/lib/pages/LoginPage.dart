import 'package:flutter/material.dart';
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
    AuthoritationModel authModel =
        await Authorization.login(_email, _password);

    if(_settings != null && authModel != null){
      _settings.access_token = authModel.token;
      _settings.refresh_token = authModel.refresh;

      _settings.setDoctor(await UserApi.getUser(_settings));

      _settings.saveSettings().then((_){
        print(authModel.token);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    _settings = Provider.of<Settings>(context);

    return new Scaffold(
      appBar: AppBar(
      title: new Text("TensionApp Login"),
      centerTitle: true,
    ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
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
              decoration: new InputDecoration(labelText: 'Password'),
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
          new RaisedButton(
            child: new Text('Login'),
            onPressed: _doLogin,
          )
        ],
      ),
    );
  }

}
