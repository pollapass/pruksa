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
  NewsprModel({
    required this.book_key,
    required this.book_date,
    required this.book_name,
    this.book_user,
    this.book_dep,
    required this.doc_key,
    required this.book_status,
  });

  NewsprModel copyWith({
    String? book_key,
    String? book_date,
    String? book_name,
    String? book_user,
    String? book_dep,
    String? doc_key,
    String? book_status,
  }) {
    return NewsprModel(
      book_key: book_key ?? this.book_key,
      book_date: book_date ?? this.book_date,
      book_name: book_name ?? this.book_name,
      book_user: book_user ?? this.book_user,
      book_dep: book_dep ?? this.book_dep,
      doc_key: doc_key ?? this.doc_key,
      book_status: book_status ?? this.book_status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'book_key': book_key,
      'book_date': book_date,
      'book_name': book_name,
      'book_user': book_user,
      'book_dep': book_dep,
      'doc_key': doc_key,
      'book_status': book_status,
    };
  }

  factory NewsprModel.fromMap(Map<String, dynamic> map) {
    return NewsprModel(
      book_key: map['book_key'] as String,
      book_date: map['book_date'] as String,
      book_name: map['book_name'] as String,
      book_user: map['book_user'] != null ? map['book_user'] as String : null,
      book_dep: map['book_dep'] != null ? map['book_dep'] as String : null,
      doc_key: map['doc_key'] as String,
      book_status: map['book_status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsprModel.fromJson(String source) =>
      NewsprModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewsprModel(book_key: $book_key, book_date: $book_date, book_name: $book_name, book_user: $book_user, book_dep: $book_dep, doc_key: $doc_key, book_status: $book_status)';
  }

  @override
  bool operator ==(covariant NewsprModel other) {
    if (identical(this, other)) return true;

    return other.book_key == book_key &&
        other.book_date == book_date &&
        other.book_name == book_name &&
        other.book_user == book_user &&
        other.book_dep == book_dep &&
        other.doc_key == doc_key &&
        other.book_status == book_status;
  }

  @override
  int get hashCode {
    return book_key.hashCode ^
        book_date.hashCode ^
        book_name.hashCode ^
        book_user.hashCode ^
        book_dep.hashCode ^
        doc_key.hashCode ^
        book_status.hashCode;
  }
}
