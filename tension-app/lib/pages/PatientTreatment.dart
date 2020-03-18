import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tension_app/api/patient.dart';
import 'package:tension_app/model/Patient.dart';
import 'package:tension_app/model/Settings.dart';

import '../constants.dart' as Constants;

class PatientTreatment extends StatefulWidget {
  bool edit;
  PatientTreatment();
  @override
  _PatientTreatmentState createState() => _PatientTreatmentState();
}

class _PatientTreatmentState extends State<PatientTreatment> {
  double spacing = 8.0;

  TextEditingController _tratamiento = TextEditingController(),
      _limiteDiastolica = TextEditingController(),
      _limitePulso = TextEditingController(),
      _limiteSistolica = TextEditingController();

  Settings _settings;

  int _rythm_type;
  

  final double _padding = 16.0;

  _fillData(Patient patient){
    if(_tratamiento.text == "")
      _tratamiento.text = (patient.treatment != null)?patient.treatment:"";
    if(_limiteDiastolica.text == "")
      _limiteDiastolica.text = (patient.limit_diastolic!=null) ? patient.limit_diastolic.toString():"";
    if(_limiteSistolica.text == "")
      _limiteSistolica.text = (patient.limit_systolic != null) ? patient.limit_systolic.toString():"";
    if(_limitePulso.text == "")
      _limitePulso.text = (patient.limit_pulse != null) ? patient.limit_pulse.toString():"";
    if(_rythm_type == null)  
      _rythm_type = patient.rythm_type;
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);

    _fillData(_settings.viewingPatient);

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
              //_settings.viewingPatient = _recreatePatient();
              _settings.viewingPatient.treatment = _tratamiento.text;
              _settings.viewingPatient.limit_diastolic = (_limiteDiastolica.text!="") ? int.parse(_limiteDiastolica.text): null;
              _settings.viewingPatient.limit_systolic = (_limiteSistolica.text != "") ? int.parse(_limiteSistolica.text): null;
              _settings.viewingPatient.limit_pulse = (_limitePulso.text != "") ? int.parse(_limitePulso.text): null;
              _settings.viewingPatient.rythm_type = _rythm_type;

              _settings.updateCahedPatientWithViewingPatient();
              await PatientApi.putViewingPatient(_settings);
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _padding),
            child: TextField(
              controller: _limiteSistolica,
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                  suffixText: "mmhg",
                  labelText: "Límite Sistólica",
                  border: OutlineInputBorder()),
            ),
          ),
          Container(
            height: spacing,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _padding),
            child: TextField(
              controller: _limiteDiastolica,
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                  suffixText: "mmHg",
                  labelText: "Límite Diastólica",
                  border: OutlineInputBorder()),
            ),
          ),
          Container(
            height: spacing,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _padding),
            child: TextField(
              controller: _limitePulso,
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                  suffixText: "bpm",
                  labelText: "Límite Frecuencia Cardiaca",
                  border: OutlineInputBorder()),
            ),
          ),
          Container(
            height: spacing,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _padding),
            child: DropdownButton<int>(
              isExpanded: true,
              value: _rythm_type,
              items: Patient.rythmTypes.asMap().entries.map((entry) {
                return new DropdownMenuItem<int>(
                  value: entry.key,
                  child: new Text(entry.value),
                );
              }).toList(),
              onChanged: (selected) {
                setState(() {
                  _rythm_type = selected;
                });
              },
            ),
          ),
          Container(
            height: spacing,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _padding),
            child: TextField(
              controller: _tratamiento,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(
                  labelText: "Tratamiento", border: OutlineInputBorder()),
            ),
          )
        ],
      ),
    );
  }
}
