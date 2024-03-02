// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DamrongModels {
  final String cid;
  final String contact_key;
  final String contact_detail;
  final String contact_name;
  final String contact_title;
  final String? fullname;
  final String contact_insert;
  final String status_name;
  final String contact_images;
  final String? contact_remark;
  DamrongModels({
    required this.cid,
    required this.contact_key,
    required this.contact_detail,
    required this.contact_name,
    required this.contact_title,
    this.fullname,
    required this.contact_insert,
    required this.status_name,
    required this.contact_images,
    this.contact_remark,
  });

  DamrongModels copyWith({
    String? cid,
    String? contact_key,
    String? contact_detail,
    String? contact_name,
    String? contact_title,
    String? fullname,
    String? contact_insert,
    String? status_name,
    String? contact_images,
    String? contact_remark,
  }) {
    return DamrongModels(
      cid: cid ?? this.cid,
      contact_key: contact_key ?? this.contact_key,
      contact_detail: contact_detail ?? this.contact_detail,
      contact_name: contact_name ?? this.contact_name,
      contact_title: contact_title ?? this.contact_title,
      fullname: fullname ?? this.fullname,
      contact_insert: contact_insert ?? this.contact_insert,
      status_name: status_name ?? this.status_name,
      contact_images: contact_images ?? this.contact_images,
      contact_remark: contact_remark ?? this.contact_remark,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'contact_key': contact_key,
      'contact_detail': contact_detail,
      'contact_name': contact_name,
      'contact_title': contact_title,
      'fullname': fullname,
      'contact_insert': contact_insert,
      'status_name': status_name,
      'contact_images': contact_images,
      'contact_remark': contact_remark,
    };
  }

  factory DamrongModels.fromMap(Map<String, dynamic> map) {
    return DamrongModels(
      cid: map['cid'] as String,
      contact_key: map['contact_key'] as String,
      contact_detail: map['contact_detail'] as String,
      contact_name: map['contact_name'] as String,
      contact_title: map['contact_title'] as String,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      contact_insert: map['contact_insert'] as String,
      status_name: map['status_name'] as String,
      contact_images: map['contact_images'] as String,
      contact_remark: map['contact_remark'] != null
          ? map['contact_remark'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DamrongModels.fromJson(String source) =>
      DamrongModels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DamrongModels(cid: $cid, contact_key: $contact_key, contact_detail: $contact_detail, contact_name: $contact_name, contact_title: $contact_title, fullname: $fullname, contact_insert: $contact_insert, status_name: $status_name, contact_images: $contact_images, contact_remark: $contact_remark)';
  }

  @override
  bool operator ==(covariant DamrongModels other) {
    if (identical(this, other)) return true;

    return other.cid == cid &&
        other.contact_key == contact_key &&
        other.contact_detail == contact_detail &&
        other.contact_name == contact_name &&
        other.contact_title == contact_title &&
        other.fullname == fullname &&
        other.contact_insert == contact_insert &&
        other.status_name == status_name &&
        other.contact_images == contact_images &&
        other.contact_remark == contact_remark;
  }

  @override
  int get hashCode {
    return cid.hashCode ^
        contact_key.hashCode ^
        contact_detail.hashCode ^
        contact_name.hashCode ^
        contact_title.hashCode ^
        fullname.hashCode ^
        contact_insert.hashCode ^
        status_name.hashCode ^
        contact_images.hashCode ^
        contact_remark.hashCode;
  }
}
