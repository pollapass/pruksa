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
  });

  AppointModel copyWith({
    String? cid,
    String? app_key,
    String? name,
    String? app_time,
    String? app_date,
    String? detail,
    String? app_phone,
    String? app_ipaddress,
    String? sub_name,
    String? sub_id,
  }) {
    return AppointModel(
      cid: cid ?? this.cid,
      app_key: app_key ?? this.app_key,
      name: name ?? this.name,
      app_time: app_time ?? this.app_time,
      app_date: app_date ?? this.app_date,
      detail: detail ?? this.detail,
      app_phone: app_phone ?? this.app_phone,
      app_ipaddress: app_ipaddress ?? this.app_ipaddress,
      sub_name: sub_name ?? this.sub_name,
      sub_id: sub_id ?? this.sub_id,
    );
  }

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
    };
  }

  factory AppointModel.fromMap(Map<String, dynamic> map) {
    return AppointModel(
      cid: map['cid'] as String,
      app_key: map['app_key'] as String,
      name: map['name'] as String,
      app_time: map['app_time'] as String,
      app_date: map['app_date'] as String,
      detail: map['detail'] as String,
      app_phone: map['app_phone'] as String,
      app_ipaddress:
          map['app_ipaddress'] != null ? map['app_ipaddress'] as String : null,
      sub_name: map['sub_name'] as String,
      sub_id: map['sub_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointModel.fromJson(String source) =>
      AppointModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppointModel(cid: $cid, app_key: $app_key, name: $name, app_time: $app_time, app_date: $app_date, detail: $detail, app_phone: $app_phone, app_ipaddress: $app_ipaddress, sub_name: $sub_name, sub_id: $sub_id)';
  }

  @override
  bool operator ==(covariant AppointModel other) {
    if (identical(this, other)) return true;

    return other.cid == cid &&
        other.app_key == app_key &&
        other.name == name &&
        other.app_time == app_time &&
        other.app_date == app_date &&
        other.detail == detail &&
        other.app_phone == app_phone &&
        other.app_ipaddress == app_ipaddress &&
        other.sub_name == sub_name &&
        other.sub_id == sub_id;
  }

  @override
  int get hashCode {
    return cid.hashCode ^
        app_key.hashCode ^
        name.hashCode ^
        app_time.hashCode ^
        app_date.hashCode ^
        detail.hashCode ^
        app_phone.hashCode ^
        app_ipaddress.hashCode ^
        sub_name.hashCode ^
        sub_id.hashCode;
  }
}
