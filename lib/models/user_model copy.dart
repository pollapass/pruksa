// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String user_key;
  final String name;
  final String lastname;

  final String user_photo;
  final String user_position;

  final String user_phone;

  final String pos_name;
  final String fullname;
  UserModel({
    required this.user_key,
    required this.name,
    required this.lastname,
    required this.user_photo,
    required this.user_position,
    required this.user_phone,
    required this.pos_name,
    required this.fullname,
  });

  UserModel copyWith({
    String? user_key,
    String? name,
    String? lastname,
    String? user_photo,
    String? user_position,
    String? user_phone,
    String? pos_name,
    String? fullname,
  }) {
    return UserModel(
      user_key: user_key ?? this.user_key,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      user_photo: user_photo ?? this.user_photo,
      user_position: user_position ?? this.user_position,
      user_phone: user_phone ?? this.user_phone,
      pos_name: pos_name ?? this.pos_name,
      fullname: fullname ?? this.fullname,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_key': user_key,
      'name': name,
      'lastname': lastname,
      'user_photo': user_photo,
      'user_position': user_position,
      'user_phone': user_phone,
      'pos_name': pos_name,
      'fullname': fullname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user_key: map['user_key'] as String,
      name: map['name'] as String,
      lastname: map['lastname'] as String,
      user_photo: map['user_photo'] as String,
      user_position: map['user_position'] as String,
      user_phone: map['user_phone'] as String,
      pos_name: map['pos_name'] as String,
      fullname: map['fullname'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(user_key: $user_key , name: $name, lastname: $lastname, user_photo: $user_photo, user_position: $user_position, user_phone: $user_phone, pos_name: $pos_name, fullname: $fullname)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.user_key == user_key &&
        other.name == name &&
        other.lastname == lastname &&
        other.user_photo == user_photo &&
        other.user_position == user_position &&
        other.user_phone == user_phone &&
        other.pos_name == pos_name &&
        other.fullname == fullname;
  }

  @override
  int get hashCode {
    return user_key.hashCode ^
        name.hashCode ^
        lastname.hashCode ^
        user_photo.hashCode ^
        user_position.hashCode ^
        user_phone.hashCode ^
        pos_name.hashCode ^
        fullname.hashCode;
  }
}
