import 'package:intl/intl.dart';

class Measure {
  DateTime timestamp;
  Measure({this.timestamp});

  String getStringTimestamp({format = "dd/MM/yyyy"}){
    return DateFormat(format).format(this.timestamp);
  }
}

class Preasure extends Measure {
  final int high;
  final int low;
  final int pulse;
  Preasure({DateTime timestamp,this.high, this.low, this.pulse}) : super(timestamp: timestamp);

  String toString(){
    return this.high.toString()+" , "+this.low.toString()+"\n"+this.pulse.toString()+" ppm";
  }

  factory Preasure.fromJson(Map<String, dynamic> json) {
    var timestamp = json['timestamp'];

    return Preasure(
      timestamp: timestamp == null ? DateTime.now() : DateTime.parse(timestamp),
      high: json['high'],
      low: json['low'],
      pulse: json['pulse'],
    );
  }
}

class Weight extends Measure {
  final double value;
  final String unit;
  Weight({DateTime timestamp, this.value, this.unit}) : super(timestamp: timestamp);

  factory Weight.fromJson(Map<String, dynamic> json) {
    var timestamp = json['timestamp'];

    return Weight(
      timestamp: DateTime.parse(timestamp),
      value: double.parse(json['weight'].toString()),
      unit: "kg" //json['unit']
    );
  }
}
