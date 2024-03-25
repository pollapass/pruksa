import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class booksendmodels {
  final String book_key;
  final String book_date;
  final String book_name;
  final String book_user;
  final String doc_key;
  final String fullname;

  final String dep_name;
  final String pos_name;
  booksendmodels({
    required this.book_key,
    required this.book_date,
    required this.book_name,
    required this.book_user,
    required this.doc_key,
    required this.fullname,
    required this.dep_name,
    required this.pos_name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'book_key': book_key,
      'book_date': book_date,
      'book_name': book_name,
      'book_user': book_user,
      'doc_key': doc_key,
      'fullname': fullname,
      'dep_name': dep_name,
      'pos_name': pos_name,
    };
  }

  factory booksendmodels.fromMap(Map<String, dynamic> map) {
    return booksendmodels(
      book_key: (map['book_key'] ?? '') as String,
      book_date: (map['book_date'] ?? '') as String,
      book_name: (map['book_name'] ?? '') as String,
      book_user: (map['book_user'] ?? '') as String,
      doc_key: (map['doc_key'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
      dep_name: (map['dep_name'] ?? '') as String,
      pos_name: (map['pos_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory booksendmodels.fromJson(String source) =>
      booksendmodels.fromMap(json.decode(source) as Map<String, dynamic>);
}
