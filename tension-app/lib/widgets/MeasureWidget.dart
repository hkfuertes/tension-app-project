import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/MeasureModel.dart';
import '../widgets.dart';
import '../constants.dart' as Constants;

class MeasureWidget extends StatelessWidget {
  MeasureWidget(this.measure, {this.number, this.height}) : super();
  final Measure measure;
  final int number;
  final int height;

  final String _nullHeight = " ¡falta la altura!";

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

    if (measure is Preasure) {
      var pressure = measure as Preasure;
      return ListTile(
        leading: leading,
        title: (pressure.high == null || pressure.low == null || pressure.low == 0 || pressure.high == 0)
            ? Text("Solo Pulso")
            : RichText(
                text:
                    TextSpan(style: TextStyle(color: Colors.black), children: [
                TextSpan(
                  text: "Alta: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: pressure.high.toString()),
                TextSpan(text: "  "),
                TextSpan(
                  text: "Baja: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: pressure.low.toString()),
              ])),
        subtitle: RichText(
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
          TextSpan(
            text: "Pulso: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: pressure.pulse.toString())
        ])),
        trailing: (pressure.timestamp != null)
            ? Text(
                pressure.timestamp.day.toString().padLeft(2, '0') +
                    " " +
                    Constants.meses_ab[pressure.timestamp.month-1] +
                    "\n" +
                    pressure.timestamp.hour.toString().padLeft(2, '0') +
                    ":" +
                    pressure.timestamp.minute.toString().padLeft(2, '0'),
                textAlign: TextAlign.end)
            : Container(),
      );
    } else {
      var weight = measure as Weight;

      return ListTile(
        leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              FontAwesomeIcons.weight,
              color: Colors.brown,
            )),
        title: RichTextWithTitleAndBody(
            title: "Peso: ", body: weight.value.toString() + " " + weight.unit),
        subtitle: RichTextWithTitleAndBody(body: (this.height == null)?this._nullHeight: " " + (weight.value / ((this.height/100) * (this.height/100))).toStringAsFixed(2), title: "IMC:",),
        trailing: Text(
            weight.timestamp.day.toString().padLeft(2, '0') +
                " " +
                Constants.meses_ab[weight.timestamp.month-1] +
                "\n" +
                weight.timestamp.hour.toString().padLeft(2, '0') +
                ":" +
                weight.timestamp.minute.toString().padLeft(2, '0'),
            textAlign: TextAlign.end),
      );
    }
  }
}
