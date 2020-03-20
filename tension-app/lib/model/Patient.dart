class Patient {
  final String id;
  String name;
  String lastName;
  String gender;
  int height;
  DateTime birthDay;

  String treatment, history;
  int limit_systolic;
  int limit_diastolic;
  int limit_pulse;
  int rythm_type;

  static Map<String, String> indicatorsDescription = {
    'erc': 'ERC',
    'fg': 'FG',
    'asma': 'Asma',
    'epoc': 'EPOC',
    'dm': 'Diabetes (DM)',
    'dislipemia': 'Dislipemia',
    'isquemic_cardiopatia': 'Cardiopatía Isquémica',
    'prev_insuf_caridiaca': 'Insuficiencia Cardiaca previa'
  };
  Map<String, bool> indicators;

  static List<String> rythmTypes = [
    'Ritmo Sinusal',
    'FA Paroxistica',
    'FA Permanente',
    'Aleteo Auricular'
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
      this.treatment,
      this.history,
      this.indicators});

  factory Patient.fromJson(Map<String, dynamic> json) {
    var indicators = {
      'erc': json['erc'].toString().toLowerCase() == 'true',
      'fg': json['fg'].toString().toLowerCase() == 'true',
      'asma': json['asma'].toString().toLowerCase() == 'true',
      'epoc': json['epoc'].toString().toLowerCase() == 'true',
      'dm': json['dm'].toString().toLowerCase() == 'true',
      'dislipemia': json['dislipemia'].toString().toLowerCase() == 'true',
      'isquemic_cardiopatia': json['isquemic_cardiopatia'].toString().toLowerCase() == 'true',
      'prev_insuf_caridiaca': json['prev_insuf_caridiaca'].toString().toLowerCase() == 'true',
    };

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
        treatment: json['treatment'],
        history: json['history'],
        indicators: indicators);
  }

  bool operator ==(Object other) {
    if (!(other is Patient))
      return false;
    else {
      return this.id == (other as Patient).id;
    }
  }
}
