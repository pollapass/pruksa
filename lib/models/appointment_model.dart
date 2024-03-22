// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppointModel {
  final String cid;
  final String app_key;
  final String name;
  final String app_time;
  final String app_date;
  final String detail;
  final String app_phone;
  final String? app_ipaddress;
  final String sub_name;
  final String sub_id;
  final String app_status;
  AppointModel({
    required this.cid,
    required this.app_key,
    required this.name,
    required this.app_time,
    required this.app_date,
    required this.detail,
    required this.app_phone,
    this.app_ipaddress,
    required this.sub_name,
    required this.sub_id,
    required this.app_status,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'app_key': app_key,
      'name': name,
      'app_time': app_time,
      'app_date': app_date,
      'detail': detail,
      'app_phone': app_phone,
      'app_ipaddress': app_ipaddress,
      'sub_name': sub_name,
      'sub_id': sub_id,
      'app_status': app_status,
    };
  }

  factory AppointModel.fromMap(Map<String, dynamic> map) {
    return AppointModel(
      cid: (map['cid'] ?? '') as String,
      app_key: (map['app_key'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      app_time: (map['app_time'] ?? '') as String,
      app_date: (map['app_date'] ?? '') as String,
      detail: (map['detail'] ?? '') as String,
      app_phone: (map['app_phone'] ?? '') as String,
      app_ipaddress: map['app_ipaddress'] != null ? map['app_ipaddress'] as String : null,
      sub_name: (map['sub_name'] ?? '') as String,
      sub_id: (map['sub_id'] ?? '') as String,
      app_status: (map['app_status'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointModel.fromJson(String source) => AppointModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
