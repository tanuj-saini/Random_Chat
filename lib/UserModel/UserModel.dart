// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String name;
  final String Latitiude;
  final String longitude;
  final String Email;
  final String UserUId;

  UserModel({
    required this.name,
    required this.Latitiude,
    required this.longitude,
    required this.Email,
    required this.UserUId,
  });

  UserModel copyWith({
    String? name,
    String? Latitiude,
    String? longitude,
    String? Email,
    String? UserUId,
  }) {
    return UserModel(
      name: name ?? this.name,
      Latitiude: Latitiude ?? this.Latitiude,
      longitude: longitude ?? this.longitude,
      Email: Email ?? this.Email,
      UserUId: UserUId ?? this.UserUId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'Latitiude': Latitiude,
      'longitude': longitude,
      'Email': Email,
      'UserUId': UserUId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      Latitiude: map['Latitiude'] as String,
      longitude: map['longitude'] as String,
      Email: map['Email'] as String,
      UserUId: map['UserUId'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, Latitiude: $Latitiude, longitude: $longitude, Email: $Email, UserUId: $UserUId)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.Latitiude == Latitiude &&
        other.longitude == longitude &&
        other.Email == Email &&
        other.UserUId == UserUId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        Latitiude.hashCode ^
        longitude.hashCode ^
        Email.hashCode ^
        UserUId.hashCode;
  }
}
