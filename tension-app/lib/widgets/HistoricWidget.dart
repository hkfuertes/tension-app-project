import 'package:flutter/material.dart';
import '../model/AuthorizationModel.dart';
import '../model/MeasureModel.dart';

import '../api/measure.dart';

import '../widgets.dart';

class HistoricWidget extends StatelessWidget {
  HistoricWidget({Key key, this.authData, this.measures, this.onRefresh}) : super(key: key);


  final AuthoritationModel authData;
  final List<Measure> measures;
  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: this.onRefresh,
      child:Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ListView.builder(
            itemCount: (measures == Null) ? 0 : measures.length,
            itemBuilder: (BuildContext ctxt, int index) {
              if (measures[index] is Preasure) {
                var preasure = measures[index] as Preasure;
                return PreasureViewWidget(
                  timestamp: preasure.timestamp,
                  high: preasure.high.toString(),
                  low: preasure.low.toString(),
                  pulse: preasure.pulse.toString(),
                );
              } else if (measures[index] is Weight) {
                var weight = measures[index] as Weight;
                return WeightViewWidget(
                  timestamp: weight.timestamp,
                  value: weight.value,
                  unit: weight.unit,
                );
              }
            },
          ),
        ),
    );
  }
}
