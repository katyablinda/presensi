class User {
  String id;
  String name;
  String token;
  String absensiID;

  User({this.id = "", this.name = "", this.token = "", this.absensiID = ""});

  factory User.fromJson(Map<String, dynamic> json) {
    // print(json['token']);
    return User(
      id: json['PegawaiID'],
      name: json['Nama'],
      token: json['token'],
      absensiID: json['AbsensiID'],
    );
  }
}
