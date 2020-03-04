import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/User.dart';

class HomePageWidgets {
  static Widget drawer(BuildContext context, User user) {
    return ListView(
      children: <Widget>[
        DrawerHeader(child: Text(user.name+" "+user.lastName)),
        ListTile(
          leading: new Icon(
            FontAwesomeIcons.user,
            color: Colors.brown,
          ),
          title: new Text('Perfil'),
          onTap: () {},
        ),
        ListTile(
          leading: new Icon(
            FontAwesomeIcons.history,
            color: Colors.brown,
          ),
          title: new Text('Historico'),
          onTap: () {
            /*
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HistoricPage(authData: authData)));
                  */
          },
        ),
        ListTile(
          leading: new Icon(
            Icons.settings,
            color: Colors.brown,
          ),
          title: new Text('Ajustes'),
          onTap: () {},
        )
      ],
    );
  }
}
