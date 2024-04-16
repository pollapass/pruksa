import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Modeluser {
    final String fullname;
  final String user_key;
  final String? user_phone;
  final String user_photo;
  final String name;
  final String lastname;
  final String user_position;
  final String pos_name;
  final String? token;
  final String moopart;
  final String addressid;
  final String user_status;
  Modeluser({
    required this.fullname,
    required this.user_key,
    this.user_phone,
    required this.user_photo,
    required this.name,
    required this.lastname,
    required this.user_position,
    required this.pos_name,
    this.token,
    required this.moopart,
    required this.addressid,
    required this.user_status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'user_key': user_key,
      'user_phone': user_phone,
      'user_photo': user_photo,
      'name': name,
      'lastname': lastname,
      'user_position': user_position,
      'pos_name': pos_name,
      'token': token,
      'moopart': moopart,
      'addressid': addressid,
      'user_status': user_status,
    };
  }

  factory Modeluser.fromMap(Map<String, dynamic> map) {
    return Modeluser(
      fullname: (map['fullname'] ?? '') as String,
      user_key: (map['user_key'] ?? '') as String,
      user_phone: map['user_phone'] != null ? map['user_phone'] as String : null,
      user_photo: (map['user_photo'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      lastname: (map['lastname'] ?? '') as String,
      user_position: (map['user_position'] ?? '') as String,
      pos_name: (map['pos_name'] ?? '') as String,
      token: map['token'] != null ? map['token'] as String : null,
      moopart: (map['moopart'] ?? '') as String,
      addressid: (map['addressid'] ?? '') as String,
      user_status: (map['user_status'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Modeluser.fromJson(String source) => Modeluser.fromMap(json.decode(source) as Map<String, dynamic>);
}
