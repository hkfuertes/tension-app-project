import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tension_app/api/patient.dart';
import 'package:tension_app/model/Patient.dart';
import 'package:tension_app/model/Settings.dart';

class PatientInfoDialog extends StatelessWidget {
  double spacing = 8.0;
  Patient patient;

  TextEditingController _nombre = TextEditingController(),
      _appellido = TextEditingController(),
      _nacimiento = TextEditingController(),
      _altura = TextEditingController();

  Settings _settings;

  DateTime _selectedDate;
  String _genero = "Male";

  PatientInfoDialog({this.patient}) {
    if (this.patient != null) {
      _nombre.text = this.patient.name;
      _appellido.text = this.patient.lastName;
      _genero = this.patient.gender;
      _nacimiento.text = this.patient.birthDay.year.toString() +
          "-" +
          this.patient.birthDay.month.toString().padLeft(2, "0") +
          "-" +
          this.patient.birthDay.day.toString().padLeft(2, "0");
      _selectedDate = this.patient.birthDay;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    return AlertDialog(
      content: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TextField(
            controller: _nombre,
            autofocus: false,
            decoration: InputDecoration(
                labelText: "Nombre", border: OutlineInputBorder()),
          ),
          Container(
            height: spacing,
          ),
          TextField(
            controller: _appellido,
            autofocus: false,
            decoration: InputDecoration(
                labelText: "Appelido", border: OutlineInputBorder()),
          ),
          Container(
            height: spacing,
          ),
          new DropdownButton<String>(
            isExpanded: true,
            value: _genero,
            items: <String>['Male', 'Female'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (selected) {
              _genero = selected;
            },
          ),
          Container(
            height: spacing,
          ),
          TextField(
            controller: _nacimiento,
            keyboardType: TextInputType.number,
            autofocus: false,
            onTap: () async {
              _selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().add(Duration(days: -10 * 365)),
                  lastDate: DateTime.now().add(Duration(days: 10 * 365)));
              _nacimiento.text = _selectedDate.day.toString().padLeft(2, "0") + "-" +
                  _selectedDate.month.toString().padLeft(2, "0") + "-" +
                  _selectedDate.year.toString();
            },
            decoration: InputDecoration(
                labelText: "Nacimiento", border: OutlineInputBorder()),
          ),
          Container(
            height: spacing,
          ),
          TextField(
            controller: _altura,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
                suffixText: "cm",
                labelText: "Altura",
                border: OutlineInputBorder()),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Guardar"),
          onPressed: () async {
            if (patient == null) {
              await PatientApi.postPatient(_settings, _recreatePatient());
            } else {
              await PatientApi.putPatient(_settings, _recreatePatient());
            }
            Navigator.of(context).pop();
          },
        )
      ],
      title: Text("Paciente"),
    );
  }

  Patient _recreatePatient() {
    return Patient(
        id: (patient == null) ? "NEW" : patient.id,
        name: this._nombre.text,
        lastName: this._appellido.text,
        gender: this._genero,
        height: int.parse(this._altura.text),
        birthDay: _selectedDate);
  }
}
