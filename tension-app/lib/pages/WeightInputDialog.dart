import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/measure.dart';
import '../model/MeasureModel.dart';
import '../model/Settings.dart';

class WeightInputDialog extends StatelessWidget {
  static final _weightFormKey = GlobalKey<FormState>();
  double _value;
  String _units = "Kg";

  TextEditingController _controller = TextEditingController();

  Settings _settings;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _settings = Provider.of<Settings>(context);
    return ListView(shrinkWrap: true, children: [
      TextField(
        controller: _controller,
        style: new TextStyle(fontSize: 30, color: Colors.black),
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
            suffixText: "Kg", labelText: "Peso", border: OutlineInputBorder()),
      ),
    ]);
  }

  static AlertDialog getDialog() {
    var dialog = WeightInputDialog();
    return AlertDialog(
      //title: Text("Introducir Peso:"),
      content: dialog,
      actions: <Widget>[
        FlatButton(
          child: Text("Guardar"),
          onPressed: () {
            dialog._postValue();
          },
        )
      ],
    );
  }

  _postValue() {
    if(_settings != null){
      MeasureApi().postWeight(_settings, _settings.viewingPatient.id ,double.parse(_controller.text), "Kg").then((postCorrect){
        if(_context != null && postCorrect){
          _settings.cachedMeasures.add(Weight(timestamp: DateTime.now(),value: double.parse(_controller.text), unit: "Kg"));
          Navigator.of(_context).pop();
        }

          
      });
    }
  }
}
