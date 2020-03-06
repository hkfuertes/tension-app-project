import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'StatsPage.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';
import '../model/Settings.dart';

import '../constants.dart' as Constants;

class MainFramework extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainFrameworkState();
  }
}

class _MainFrameworkState extends State<MainFramework> {
  Settings _settings;
  int _currentIndex = 0;
  final List<Widget> _pages = [HomePage(), StatsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int position) {
          setState(() {
            _currentIndex = position;
          });
        },
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Pacientes")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.fileMedicalAlt),
              title: Text("Estadísticas")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userMd), title: Text("Perfil")),
        ],
      ),
    );
  }
}
