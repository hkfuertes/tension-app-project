class Patient {
  final String id;
  final String name;
  final String lastName;
  final String gender;
  final int height;
  final DateTime birthDay;

  Patient({this.id, this.name, this.lastName, this.gender, this.height, this.birthDay});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'].toString(),
      name: json['name'],
      lastName: json['lastName'],
      gender: json['gender'],
      height: json['height'],
      birthDay: json['birthday'] != null ? DateTime.parse(json['birthday']): null,
    );
  }
}
