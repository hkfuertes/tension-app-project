class AuthoritationModel {
  final String token;
  final String refresh;

  AuthoritationModel({this.token, this.refresh});

  factory AuthoritationModel.fromJson(Map<String, dynamic> json) {
    return AuthoritationModel(
      token: json['access_token'],
      refresh: json['refresh_token'],
    );
  }
  factory AuthoritationModel.fromPrefs(List prefs) {
    return AuthoritationModel(
      token: prefs[0],
      refresh: prefs[1],
    );
  }
}
