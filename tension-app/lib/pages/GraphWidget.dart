import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphWidget extends StatelessWidget {
  final series;
  final title;
  List<Widget> circles = [];

  double _spacing = 4;

  GraphWidget({this.series, this.title, position, total = 1}){
    if(total != 1)
      for(var i = 0; i<total; i++){
        if(position-1 == i)
          circles.add(fullCircle);
        else
          circles.add(emptyCircle);
        circles.add(Container(width: _spacing,));
      }
  }

  static double circleSize = 10;
  Widget fullCircle = Container(
    width: circleSize,
    height: circleSize,
    decoration: BoxDecoration(
      color: Colors.brown,
      shape: BoxShape.circle,
    ),
  );
  Widget emptyCircle = Container(
    width: circleSize,
    height: circleSize,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.brown),
      shape: BoxShape.circle,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: circles,),
              Text(
                title,
                style: TextStyle(color: Colors.brown, fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: charts.TimeSeriesChart(series),
            ),
          ),
        ),
      ],
    );
  }
}
