class Patient {
  final String id;
  String name;
  String lastName;
  String gender;
  int height;
  DateTime birthDay;

  String treatment;
  int limit_systolic;
  int limit_diastolic;
  int limit_pulse;
  int rythm_type;

  static List<String> rythmTypes = [
    'Ritmo Sinusal',
    'FA Paroxistica',
    'FA Permanente'
  ];

  Patient(
      {this.id,
      this.name,
      this.lastName,
      this.gender,
      this.height,
      this.birthDay,
      this.limit_pulse,
      this.limit_systolic,
      this.limit_diastolic,
      this.rythm_type = 0,
      this.treatment});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
        id: json['id'].toString(),
        name: json['name'],
        lastName: json['lastName'],
        gender: json['gender'],
        height: json['height'],
        birthDay:
            json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
        limit_systolic: json['limit_systolic'],
        limit_diastolic: json['limit_diastolic'],
        limit_pulse: json['limit_pulse'],
        rythm_type: json['rythm_type'],
        treatment: json['treatment']);
  }

  bool operator ==(Object other) {
    if (!(other is Patient))
      return false;
    else {
      return this.id == (other as Patient).id;
    }
  }
}
