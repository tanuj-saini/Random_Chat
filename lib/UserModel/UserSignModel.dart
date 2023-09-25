// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserSignModel {
  final String Password;
  final String Email;
  UserSignModel({
    required this.Password,
    required this.Email,
  });

  UserSignModel copyWith({
    String? Password,
    String? Email,
  }) {
    return UserSignModel(
      Password: Password ?? this.Password,
      Email: Email ?? this.Email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Password': Password,
      'Email': Email,
    };
  }

  factory UserSignModel.fromMap(Map<String, dynamic> map) {
    return UserSignModel(
      Password: map['Password'] as String,
      Email: map['Email'] as String,
    );
  }

  @override
  String toString() => 'UserSignModel(Password: $Password, Email: $Email)';

  @override
  bool operator ==(covariant UserSignModel other) {
    if (identical(this, other)) return true;

    return other.Password == Password && other.Email == Email;
  }

  @override
  int get hashCode => Password.hashCode ^ Email.hashCode;
}
