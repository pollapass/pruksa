// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RedcrossModel {
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

  RedcrossModel copyWith({
    String? cid,
    String? red_id,
    String? remark,
    String? red_date,
    String? images,
    String? type_name,
    String? fullname,
    String? status_name,
    String? detail,
    String? help_name,
  }) {
    return RedcrossModel(
      cid: cid ?? this.cid,
      red_id: red_id ?? this.red_id,
      remark: remark ?? this.remark,
      red_date: red_date ?? this.red_date,
      images: images ?? this.images,
      type_name: type_name ?? this.type_name,
      fullname: fullname ?? this.fullname,
      status_name: status_name ?? this.status_name,
      detail: detail ?? this.detail,
      help_name: help_name ?? this.help_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      cid: map['cid'] as String,
      red_id: map['red_id'] as String,
      remark: map['remark'] as String,
      red_date: map['red_date'] as String,
      images: map['images'] as String,
      type_name: map['type_name'] as String,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      status_name: map['status_name'] as String,
      detail: map['detail'] != null ? map['detail'] as String : null,
      help_name: map['help_name'] != null ? map['help_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RedcrossModel.fromJson(String source) =>
      RedcrossModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RedcrossModel(cid: $cid, red_id: $red_id, remark: $remark, red_date: $red_date, images: $images, type_name: $type_name, fullname: $fullname, status_name: $status_name, detail: $detail, help_name: $help_name)';
  }

  @override
  bool operator ==(covariant RedcrossModel other) {
    if (identical(this, other)) return true;

    return other.cid == cid &&
        other.red_id == red_id &&
        other.remark == remark &&
        other.red_date == red_date &&
        other.images == images &&
        other.type_name == type_name &&
        other.fullname == fullname &&
        other.status_name == status_name &&
        other.detail == detail &&
        other.help_name == help_name;
  }

  @override
  int get hashCode {
    return cid.hashCode ^
        red_id.hashCode ^
        remark.hashCode ^
        red_date.hashCode ^
        images.hashCode ^
        type_name.hashCode ^
        fullname.hashCode ^
        status_name.hashCode ^
        detail.hashCode ^
        help_name.hashCode;
  }
}
