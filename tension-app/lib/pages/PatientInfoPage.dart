import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tension_app/api/patient.dart';
import 'package:tension_app/model/Patient.dart';
import 'package:tension_app/model/Settings.dart';

class PatientInfoPage extends StatefulWidget {
  Patient patient;
  PatientInfoPage({this.patient});
  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  double spacing = 8.0;
  Patient patient;

  TextEditingController _nombre = TextEditingController(),
      _appellido = TextEditingController(),
      _nacimiento = TextEditingController(),
      _altura = TextEditingController();

  Settings _settings;

  DateTime _selectedDate;
  String _genero = "Male";

  String _selectedDateString;

  _fillWithPatient(Patient patient) {
    if (patient != null) {
      _nombre.text = patient.name;
      _appellido.text = patient.lastName;
      _genero = patient.gender;
      _nacimiento.text = patient.birthDay.year.toString() +
          "-" +
          patient.birthDay.month.toString().padLeft(2, "0") +
          "-" +
          patient.birthDay.day.toString().padLeft(2, "0");
      _selectedDate = patient.birthDay;
      _selectedDateString = _pintarFecha(_selectedDate);
    } 
  }

  @override
  Widget build(BuildContext context) {
    _fillWithPatient(this.widget.patient);
    _settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Paciente"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
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
                setState(() {
                  _genero = selected;
                });
              },
            ),
            Container(
              height: spacing,
            ),
            FlatButton.icon(
              icon: Icon(Icons.calendar_today),
              label: Text((_selectedDateString != null)
                  ? _selectedDateString
                  : "Seleccionar"),
              onPressed: () async {
                _selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate == null ? DateTime.now():_selectedDate,
                    firstDate: DateTime.now().add(Duration(days: -10 * 365)),
                    lastDate: DateTime.now().add(Duration(days: 10 * 365)));
                setState(() {
                  _selectedDateString = _pintarFecha(_selectedDate);
                });
              },
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
      ),
    );
  }

  String _pintarFecha(DateTime fecha) {
    return _selectedDate.day.toString().padLeft(2, "0") +
        "-" +
        _selectedDate.month.toString().padLeft(2, "0") +
        "-" +
        _selectedDate.year.toString();
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
