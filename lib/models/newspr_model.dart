// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NewsprModel {
  final String book_key;
  final String book_date;
  final String book_name;
  final String? book_user;
  final String? book_dep;
  final String doc_key;
  final String book_status;
    final String fullname;
  final String pos_name;
  final String dep_name;
  NewsprModel({
    required this.book_key,
    required this.book_date,
    required this.book_name,
    this.book_user,
    this.book_dep,
    required this.doc_key,
    required this.book_status,
    required this.fullname,
    required this.pos_name,
    required this.dep_name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'book_key': book_key,
      'book_date': book_date,
      'book_name': book_name,
      'book_user': book_user,
      'book_dep': book_dep,
      'doc_key': doc_key,
      'book_status': book_status,
      'fullname': fullname,
      'pos_name': pos_name,
      'dep_name': dep_name,
    };
  }

  factory NewsprModel.fromMap(Map<String, dynamic> map) {
    return NewsprModel(
      book_key: (map['book_key'] ?? '') as String,
      book_date: (map['book_date'] ?? '') as String,
      book_name: (map['book_name'] ?? '') as String,
      book_user: map['book_user'] != null ? map['book_user'] as String : null,
      book_dep: map['book_dep'] != null ? map['book_dep'] as String : null,
      doc_key: (map['doc_key'] ?? '') as String,
      book_status: (map['book_status'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
      pos_name: (map['pos_name'] ?? '') as String,
      dep_name: (map['dep_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsprModel.fromJson(String source) => NewsprModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
