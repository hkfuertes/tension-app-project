import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tension_app/api/patient.dart';
import 'package:tension_app/model/Patient.dart';
import 'package:tension_app/model/Settings.dart';

import '../constants.dart' as Constants;

class PatientInfoPage extends StatefulWidget {
  bool edit;
  PatientInfoPage({this.edit = false});
  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  double spacing = 8.0;
  Patient patient;

  TextEditingController _nombre = TextEditingController(),
      _appellido = TextEditingController(),
      _altura = TextEditingController();

  Settings _settings;

  DateTime _selectedDate;
  int _genero = -1;
  List<String> _generosIngles = ['Male', 'Female'];
  List<String> _generosSpanish = ['Hombre', 'Mujer'];

  DateTime _firstDate = DateTime.now().add(Duration(days: -100 * 365));
  DateTime _lastDate = DateTime.now().add(Duration(days: 10 * 365));

  String _selectedDateString;

  _fillWithPatient(Patient patient) {
    if (patient != null) {
      if (_nombre.text == "") _nombre.text = patient.name;
      if (_appellido.text == "") _appellido.text = patient.lastName;

      if (_genero == -1) {
        _genero = _generosIngles.indexOf(
            patient.gender[0].toUpperCase() + patient.gender.substring(1));
        _genero = (_genero == -1)
            ? _generosSpanish.indexOf(
                patient.gender[0].toUpperCase() + patient.gender.substring(1))
            : _genero;
        _genero = (_genero == -1) ? 0 : _genero;
      }

      if (_altura.text == "") _altura.text = patient.height.toString();

      if (_selectedDate == null) _selectedDate = patient.birthDay;
      _selectedDateString = _pintarFecha(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    if (this.widget.edit) _fillWithPatient(_settings.viewingPatient);

    if (_genero == -1) _genero = 0;

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
              _settings.viewingPatient = _recreatePatient();
              if (this.widget.edit) {
                _settings.updateCahedPatientWithViewingPatient();
                await PatientApi.putViewingPatient(_settings);
              } else {
                _settings.cachedPatientList
                    .add(await PatientApi.postViewingPatient(_settings));
              }
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 2 * spacing,
          ),
          SizedBox(
            height: 100.0,
            width: 100.0,
            child: CircleAvatar(
              child: Icon(
                (_genero == 0)
                    ? FontAwesomeIcons.userAlt
                    : FontAwesomeIcons.userAlt,
                size: 50.0,
              ),
            ),
          ),
          Container(
            height: 2 * spacing,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                      labelText: "Apelido", border: OutlineInputBorder()),
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
                Container(
                  height: spacing,
                ),
                DropdownButton<int>(
                  isExpanded: true,
                  value: _genero,
                  items: _generosSpanish.asMap().entries.map((entry) {
                    return new DropdownMenuItem<int>(
                      value: entry.key,
                      child: new Text(entry.value),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlineButton.icon(
              icon: Icon(Icons.calendar_today),
              label: Text((_selectedDateString != null)
                  ? _selectedDateString
                  : "Seleccionar"),
              onPressed: () async {
                _selectedDate = await showDatePicker(
                    context: context,
                    initialDate: (_selectedDate == null ||
                            _selectedDate.isBefore(_firstDate))
                        ? DateTime.now()
                        : _selectedDate,
                    firstDate: _firstDate,
                    lastDate: _lastDate);
                print(_pintarFecha(_selectedDate));
                setState(() {
                  _selectedDateString = _pintarFecha(_selectedDate);
                });
              },
            ),
          ),
          (this.widget.edit)
              ? Container(
                  height: spacing,
                )
              : Container(),
          (this.widget.edit)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: OutlineButton.icon(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actions: <Widget>[
                              FlatButton(
                                child: Text(Constants.delete_patient_button),
                                onPressed: () async {
                                  if (await PatientApi.deleteViewingPatient(
                                      _settings)) {
                                    _settings.cachedPatientList
                                        .remove(_settings.viewingPatient);
                                    Navigator.pop(context);
                                    _settings.viewingPatient = null;
                                    _settings.refreshUI();
                                  }
                                },
                              )
                            ],
                            content: Text(Constants.delete_patient_text
                                .replaceAll("<patient.name>",
                                    _settings.viewingPatient.name)),
                            title: Text(Constants.delete_patient_title),
                          );
                        },
                      );
                    },
                    label: Text("Eliminar"),
                    icon: Icon(Icons.delete),
                  ),
                )
              : Container()
        ],
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
    if (this.widget.edit) {
      _settings.viewingPatient.name = this._nombre.text;
      _settings.viewingPatient.lastName = this._appellido.text;
      _settings.viewingPatient.gender = this._generosIngles[this._genero];
      _settings.viewingPatient.height = int.parse(this._altura.text);
      _settings.viewingPatient.birthDay = _selectedDate;
      return _settings.viewingPatient;
    } else
      return Patient(
        id: "NEW",
        name: this._nombre.text,
        lastName: this._appellido.text,
        gender: this._generosIngles[this._genero],
        height: int.parse(this._altura.text),
        birthDay: _selectedDate,
      );
  }
}
