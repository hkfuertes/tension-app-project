import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tension_app/model/Patient.dart';

import '../widgets.dart';

class PatientListTile extends StatelessWidget {

  PatientListTile({this.patient, this.onTap, this.withAvatar=true}) : super();
  final Patient patient;
  final Function onTap;
  bool withAvatar;

  @override
  Widget build(BuildContext context) {
    var age = (DateTime.now().difference(patient.birthDay??DateTime.now()).inDays / 365).floor().toString();
    return ListTile(
      
      trailing: (withAvatar) ? Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon((patient.gender == "Female") ?FontAwesomeIcons.venus: FontAwesomeIcons.mars)):Container(),
      
      title: Text(patient.name + " " + patient.lastName),
      subtitle:Row(
        children: <Widget>[
          RichTextWithTitleAndBody(title: "Edad: ", body: age + " años"),
          SizedBox(
            width: 10,
          ),
          RichTextWithTitleAndBody(title: "Altura: ", body: patient.height.toString() + " cm"),
        ],
      ),
      onTap: (){
        this.onTap(patient);
      } ,
    );
  }
}