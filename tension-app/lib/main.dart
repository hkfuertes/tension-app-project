import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tension_app/pages/MainFramework.dart';
import './api/user.dart';
import './model/Settings.dart';
import './pages/LoginPage.dart';

import 'model/AuthorizationModel.dart';
import 'api/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  Settings settings = new Settings();
  settings.fill(prefs);

  //Refresh the token each time
  //TODO: Decode JWT and save exp date.
  //await refreshToken(settings);

  var doctor = await UserApi.getUser(settings);
  settings.setDoctor(doctor);
  settings.refreshUI();

  runApp(ChangeNotifierProvider<Settings>(
      create: (context) => settings, child: MyApp()));
}

void refreshToken(Settings settings) async {
  if (settings.refresh_token != "") {
    AuthoritationModel authModel =
        await Authorization.refresh(settings.refresh_token);

    if (settings != null && authModel != null) {
      settings.access_token = authModel.token;

      settings.saveSettings(toast: false).then((_) {
        print(authModel.token);
      });
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<Settings>(context);

    return MaterialApp(
      title: 'TensionApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: settings.access_token != "" ? MainFramework() : LoginPage(),
    );
  }
}
