import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;

class ProfilePage extends StatelessWidget {

  Settings _settings;

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.profile_title),
        leading: Icon(Icons.person),
      ),

      body: SingleChildScrollView(child: 
      Column(children: <Widget>[
        Center(child: Padding(
          padding: const EdgeInsets.only(left:32.0, right: 32.0, top: 32.0),
          child: Icon(Icons.person, size: 128.0,),
        )),
        Center(child: Text(_settings.doctor.name + " " + _settings.doctor.lastName, style: TextStyle(fontSize: 24.0),),),
        FlatButton(child: Text("Cerrar Sesión"), onPressed: (){
          _settings.logout();
        },)

      ],),));
  }
}
