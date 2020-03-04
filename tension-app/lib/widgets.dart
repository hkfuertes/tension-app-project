import "package:flutter/material.dart";
import 'constants.dart' as Constants;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model/MeasureModel.dart';

class TakeWidget extends StatelessWidget {
  TakeWidget() : super();

  int alta, baja, pulso;

  Preasure getValues() {
    //Un take no tiene timestamp, solo la medida final.
    return Preasure(high: alta, low: baja, pulse: pulso, timestamp: null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
                suffixText: "mmHg",
                hintText: "140",
                labelText: "Alta",
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
                labelText: "Baja",
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
                labelText: "Pulso",
                border: OutlineInputBorder()),
            onChanged: (String val) {
              this.pulso = int.parse(val);
            },
          ),
        ],
      ),
    );
  }
}

class WeightWidget extends StatefulWidget {
  WeightWidget({this.onChanged}) : super();
  final Function onChanged;

  @override
  State<StatefulWidget> createState() {
    return new WeightWidgetState(onChanged: onChanged);
  }
}

class WeightWidgetState extends State<WeightWidget> {
  WeightWidgetState({this.onChanged}) : super();
  final Function onChanged;

  String selected = null;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: "Peso",
                      ),
                    ),
                    DropdownButtonFormField(
                      value: selected,
                      hint: Text("Unidades"),
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(child: Text("Kg"), value: "Kg"),
                        DropdownMenuItem(
                          child: Text("lbs"),
                          value: "lbs",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selected = value;
                        });
                        onChanged(value);
                      },
                    )
                  ],
                ))));
  }
}

class RichTextWithTitleAndBody extends StatelessWidget {
  RichTextWithTitleAndBody({this.title, this.body}) : super();
  final String title;
  final String body;

  var bold = TextStyle(fontWeight: FontWeight.bold);
  var defaultStyle = TextStyle(fontSize: 14.0, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: new TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          new TextSpan(text: title, style: this.bold),
          new TextSpan(text: body),
        ],
      ),
    );
  }
}

class PreasureViewWidget extends StatelessWidget {
  PreasureViewWidget(
      {this.timestamp, this.high, this.low, this.pulse, this.number = -1})
      : super();
  final DateTime timestamp;
  final String high;
  final String low;
  final String pulse;
  final int number;

  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (this.number != -1) {
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
    /*else{
      leading = Container( 
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.brown,
          border: Border.all(color: Colors.brown),
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
        Text(this.timestamp.day.toString().padLeft(2, '0'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        Text(Constants.meses_ab[this.timestamp.month], style: TextStyle(color: Colors.white),)
        ]));
    }*/
    return ListTile(
      leading: leading,
      title: Row(
        children: <Widget>[
          RichTextWithTitleAndBody(title: "Alta: ", body: this.high.toString()),
          SizedBox(
            width: 10,
          ),
          RichTextWithTitleAndBody(title: "Baja: ", body: this.low),
        ],
      ),
      subtitle: RichTextWithTitleAndBody(title: "Pulso: ", body: this.pulse),
      trailing: Text(
          timestamp.day.toString().padLeft(2, '0') +
              " " +
              Constants.meses_ab[this.timestamp.month] +
              "\n" +
              this.timestamp.hour.toString().padLeft(2, '0') +
              ":" +
              this.timestamp.minute.toString().padLeft(2, '0'),
          textAlign: TextAlign.end),
    );
  }
}

class WeightViewWidget extends StatelessWidget {
  WeightViewWidget({this.timestamp, this.value, this.unit}) : super();
  final DateTime timestamp;
  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            FontAwesomeIcons.weight,
            color: Colors.brown,
          )),
      title: RichTextWithTitleAndBody(
          title: "Peso: ", body: this.value.toString() + " " + this.unit),
      trailing: Text(
          timestamp.day.toString().padLeft(2, '0') +
              " " +
              Constants.meses_ab[this.timestamp.month] +
              "\n" +
              this.timestamp.hour.toString().padLeft(2, '0') +
              ":" +
              this.timestamp.minute.toString().padLeft(2, '0'),
          textAlign: TextAlign.end),
    );
  }
}
