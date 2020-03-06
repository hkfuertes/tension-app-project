class User {
  final String email;
  String name;
  String lastName;
  final String gender;
  final String height;
  final DateTime birthDay;

  User({this.email, this.name, this.lastName, this.gender, this.height, this.birthDay});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
      lastName: json['lastName'],
      //gender: json['gender'],
      //height: json['height'],
      //birthDay: json['birthDay'],
    );
  }
}
