import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ActiveListModel {
    final String act_key;
  final String user_key;
  final String act_date;
  final String report_date;
  final String titel;
  final String act_detail;
  final String act_images;
  final String name;
  final String lastname;
  final String user_photo;
  final String items_name;
  ActiveListModel({
    required this.act_key,
    required this.user_key,
    required this.act_date,
    required this.report_date,
    required this.titel,
    required this.act_detail,
    required this.act_images,
    required this.name,
    required this.lastname,
    required this.user_photo,
    required this.items_name,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'act_key': act_key,
      'user_key': user_key,
      'act_date': act_date,
      'report_date': report_date,
      'titel': titel,
      'act_detail': act_detail,
      'act_images': act_images,
      'name': name,
      'lastname': lastname,
      'user_photo': user_photo,
      'items_name': items_name,
    };
  }

  factory ActiveListModel.fromMap(Map<String, dynamic> map) {
    return ActiveListModel(
      act_key: (map['act_key'] ?? '') as String,
      user_key: (map['user_key'] ?? '') as String,
      act_date: (map['act_date'] ?? '') as String,
      report_date: (map['report_date'] ?? '') as String,
      titel: (map['titel'] ?? '') as String,
      act_detail: (map['act_detail'] ?? '') as String,
      act_images: (map['act_images'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      lastname: (map['lastname'] ?? '') as String,
      user_photo: (map['user_photo'] ?? '') as String,
      items_name: (map['items_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActiveListModel.fromJson(String source) => ActiveListModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
