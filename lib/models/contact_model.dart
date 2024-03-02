// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContactModel {
  final String cid;
  final String contact_key;
  final String contact_detail;
  final String contact_name;
  final String contact_title;
  final String contact_insert;
  final String? contact_cover;
  final String? view;
  final String? anwser;
  ContactModel({
    required this.cid,
    required this.contact_key,
    required this.contact_detail,
    required this.contact_name,
    required this.contact_title,
    required this.contact_insert,
    this.contact_cover,
    this.view,
    this.anwser,
  });

  ContactModel copyWith({
    String? cid,
    String? contact_key,
    String? contact_detail,
    String? contact_name,
    String? contact_title,
    String? contact_insert,
    String? contact_cover,
    String? view,
    String? anwser,
  }) {
    return ContactModel(
      cid: cid ?? this.cid,
      contact_key: contact_key ?? this.contact_key,
      contact_detail: contact_detail ?? this.contact_detail,
      contact_name: contact_name ?? this.contact_name,
      contact_title: contact_title ?? this.contact_title,
      contact_insert: contact_insert ?? this.contact_insert,
      contact_cover: contact_cover ?? this.contact_cover,
      view: view ?? this.view,
      anwser: anwser ?? this.anwser,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'contact_key': contact_key,
      'contact_detail': contact_detail,
      'contact_name': contact_name,
      'contact_title': contact_title,
      'contact_insert': contact_insert,
      'contact_cover': contact_cover,
      'view': view,
      'anwser': anwser,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      cid: map['cid'] as String,
      contact_key: map['contact_key'] as String,
      contact_detail: map['contact_detail'] as String,
      contact_name: map['contact_name'] as String,
      contact_title: map['contact_title'] as String,
      contact_insert: map['contact_insert'] as String,
      contact_cover:
          map['contact_cover'] != null ? map['contact_cover'] as String : null,
      view: map['view'] != null ? map['view'] as String : null,
      anwser: map['anwser'] != null ? map['anwser'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContactModel(cid: $cid, contact_key: $contact_key, contact_detail: $contact_detail, contact_name: $contact_name, contact_title: $contact_title, contact_insert: $contact_insert, contact_cover: $contact_cover, view: $view, anwser: $anwser)';
  }

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;

    return other.cid == cid &&
        other.contact_key == contact_key &&
        other.contact_detail == contact_detail &&
        other.contact_name == contact_name &&
        other.contact_title == contact_title &&
        other.contact_insert == contact_insert &&
        other.contact_cover == contact_cover &&
        other.view == view &&
        other.anwser == anwser;
  }

  @override
  int get hashCode {
    return cid.hashCode ^
        contact_key.hashCode ^
        contact_detail.hashCode ^
        contact_name.hashCode ^
        contact_title.hashCode ^
        contact_insert.hashCode ^
        contact_cover.hashCode ^
        view.hashCode ^
        anwser.hashCode;
  }
}
