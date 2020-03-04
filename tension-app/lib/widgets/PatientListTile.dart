import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tension_app/model/Patient.dart';

import '../widgets.dart';

class PatientListTile extends StatelessWidget {

  PatientListTile({this.patient, this.onTap}) : super();
  final Patient patient;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var age = (DateTime.now().difference(patient.birthDay??DateTime.now()).inDays / 365).floor().toString();
    return ListTile(
      /*
      leading: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon(FontAwesomeIcons.user)),
        */
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