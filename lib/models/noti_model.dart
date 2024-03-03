import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class NotiMode {
  final String title;

  final String message;
  NotiMode({
    required this.title,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'message': message,
    };
  }

  factory NotiMode.fromMap(Map<String, dynamic> map) {
    return NotiMode(
      title: (map['title'] ?? '') as String,
      message: (map['message'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotiMode.fromJson(String source) =>
      NotiMode.fromMap(json.decode(source) as Map<String, dynamic>);
}
