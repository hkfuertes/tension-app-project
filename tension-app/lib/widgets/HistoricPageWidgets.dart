import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/User.dart';

class HistoricPageWidgets {
  static Widget modalSheet(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(
                  FontAwesomeIcons.heartbeat,
                  color: Colors.brown,
                ),
                title: new Text('Tension'),
                onTap: () {
                  /*
                        Navigator.of(context)
                            .pushReplacementNamed(InputPreasurePage.tag);
                            */
                },
              ),
              new ListTile(
                leading: new Icon(
                  FontAwesomeIcons.weight,
                  color: Colors.brown,
                ),
                title: new Text('Peso'),
                onTap: () {
                  /*
                        Navigator.of(context)
                            .pushReplacementNamed(InputWeightPage.tag);
                            */
                },
              ),
            ],
          )),
    );
  }
}