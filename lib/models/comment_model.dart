import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommentModel {
  final String fullname;
  final String act_key;
  final String user_key;
  final String com_detail;
  final String com_date;
  final String user_photo;
  CommentModel({
    required this.fullname,
    required this.act_key,
    required this.user_key,
    required this.com_detail,
    required this.com_date,
    required this.user_photo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'act_key': act_key,
      'user_key': user_key,
      'com_detail': com_detail,
      'com_date': com_date,
      'user_photo': user_photo,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      fullname: (map['fullname'] ?? '') as String,
      act_key: (map['act_key'] ?? '') as String,
      user_key: (map['user_key'] ?? '') as String,
      com_detail: (map['com_detail'] ?? '') as String,
      com_date: (map['com_date'] ?? '') as String,
      user_photo: (map['user_photo'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
