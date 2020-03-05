import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tension_app/api/patient.dart';
import 'package:tension_app/model/Patient.dart';
import 'package:tension_app/model/Settings.dart';

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

  DateTime _selectedDate = DateTime.now();
  int _genero = -1;
  List<String> _generosIngles = ['Male', 'Female'];
  List<String> _generosSpanish = ['Hombre', 'Mujer'];

  DateTime _firstDate = DateTime.now().add(Duration(days: -100 * 365));
  DateTime _lastDate = DateTime.now().add(Duration(days: 10 * 365));

  String _selectedDateString;

  _fillWithPatient(Patient patient) {
    if (patient != null) {
      if(_nombre.text == "")
        _nombre.text = patient.name;
      if(_appellido.text == "")
        _appellido.text = patient.lastName;

      if(_genero == -1){
        _genero = _generosIngles.indexOf(patient.gender[0].toUpperCase() + patient.gender.substring(1));
        _genero = (_genero == -1) ? _generosSpanish.indexOf(patient.gender[0].toUpperCase() + patient.gender.substring(1)): 0;
      }

      if(_altura.text=="")
        _altura.text = patient.height.toString();

      if(_selectedDate == DateTime.now())
        _selectedDate = patient.birthDay;
      if(_selectedDateString == null)
        _selectedDateString = _pintarFecha(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    if(this.widget.edit)
      _fillWithPatient(_settings.viewingPatient);
    
    if(_genero == -1) _genero = 0;

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
              _settings.viewingPatient = _recreatePatient();
              if (this.widget.edit) {
                await PatientApi.putViewingPatient(_settings);
              } else {
                await PatientApi.postViewingPatient(_settings);
              }
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            new DropdownButton<int>(
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
            OutlineButton.icon(
              icon: Icon(Icons.calendar_today),
              label: Text((_selectedDateString != null)
                  ? _selectedDateString
                  : "Seleccionar"),
              onPressed: () async {
                _selectedDate = await showDatePicker(
                    context: context,
                    initialDate:
                        (_selectedDate == null || _selectedDate.isBefore(_firstDate)) ? DateTime.now() : _selectedDate,
                    firstDate: _firstDate,
                    lastDate: _lastDate);
                    print(_pintarFecha(_selectedDate));
                setState(() {
                  _selectedDateString = _pintarFecha(_selectedDate);
                });
              },
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
        id: (!this.widget.edit) ? "NEW" : _settings.viewingPatient.id,
        name: this._nombre.text,
        lastName: this._appellido.text,
        gender: this._generosIngles[this._genero],
        height: int.parse(this._altura.text),
        birthDay: _selectedDate);
  }
}
