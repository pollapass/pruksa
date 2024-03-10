// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RedcrossModel {
  final String name;
  final String lastname;
  final String phone;
  final String lat;
  final String lng;
  final String cid;
  final String red_id;
  final String remark;
  final String red_date;
  final String images;
  final String type_name;
  final String? fullname;
  final String status_name;
  final String? detail;
  final String? help_name;
  RedcrossModel({
    required this.name,
    required this.lastname,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.cid,
    required this.red_id,
    required this.remark,
    required this.red_date,
    required this.images,
    required this.type_name,
    this.fullname,
    required this.status_name,
    this.detail,
    this.help_name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'lastname': lastname,
      'phone': phone,
      'lat': lat,
      'lng': lng,
      'cid': cid,
      'red_id': red_id,
      'remark': remark,
      'red_date': red_date,
      'images': images,
      'type_name': type_name,
      'fullname': fullname,
      'status_name': status_name,
      'detail': detail,
      'help_name': help_name,
    };
  }

  factory RedcrossModel.fromMap(Map<String, dynamic> map) {
    return RedcrossModel(
      name: (map['name'] ?? '') as String,
      lastname: (map['lastname'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      lat: (map['lat'] ?? '') as String,
      lng: (map['lng'] ?? '') as String,
      cid: (map['cid'] ?? '') as String,
      red_id: (map['red_id'] ?? '') as String,
      remark: (map['remark'] ?? '') as String,
      red_date: (map['red_date'] ?? '') as String,
      images: (map['images'] ?? '') as String,
      type_name: (map['type_name'] ?? '') as String,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      status_name: (map['status_name'] ?? '') as String,
      detail: map['detail'] != null ? map['detail'] as String : null,
      help_name: map['help_name'] != null ? map['help_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RedcrossModel.fromJson(String source) => RedcrossModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
