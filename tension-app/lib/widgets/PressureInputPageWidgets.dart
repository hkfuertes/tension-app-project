import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/MeasureModel.dart';

class TakeWidget extends StatelessWidget {
  TakeWidget() : super();

  int alta, baja, pulso;

  Preasure getValues() {
    //Un take no tiene timestamp, solo la medida final.
    return Preasure(
        high: alta, low: baja, pulse: pulso, timestamp: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: InputDecoration(
              suffixText: "mmHg",
              hintText: "140",
              labelText: "Sistólica",
              border: OutlineInputBorder()),
          onChanged: (String val) {
            this.alta = int.parse(val);
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: InputDecoration(
              suffixText: "mmHg",
              hintText: "80",
              labelText: "Diastólica",
              border: OutlineInputBorder()),
          onChanged: (String val) {
            this.baja = int.parse(val);
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: InputDecoration(
              suffixText: "bpm",
              hintText: "70",
              labelText: "Frecuencia",
              border: OutlineInputBorder()),
          onChanged: (String val) {
            this.pulso = int.parse(val);
          },
        ),
      ],
    );
  }
}

class TakeViewWidget extends StatelessWidget {
  TakeViewWidget(this._pressure, {this.number}) : super();
  final Preasure _pressure;
  final int number;

  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (this.number != null) {
      leading = CircleAvatar(child: Text(number.toString()));
    } else {
      //leading = CircleAvatar(child: Text(this.timestamp.day.toString().padLeft(2,'0')));
      leading = Padding(
          padding: EdgeInsets.only(left: 10),
          child: leading = Icon(
            FontAwesomeIcons.heartbeat,
            color: Colors.brown,
          ));
    }

    return ListTile(
        leading: leading,
        title: (_pressure.high == null || _pressure.low == null)
            ? Text("Solo Pulso")
            : RichText(
                text:
                    TextSpan(style: TextStyle(color: Colors.black), children: [
                TextSpan(
                  text: "Alta: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: _pressure.high.toString()),
                TextSpan(text: "  "),
                TextSpan(
                  text: "Baja: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: _pressure.low.toString()),
              ])),
        subtitle: RichText(
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
          TextSpan(
            text: "Pulso: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: _pressure.pulse.toString())
        ])));
  }
}
