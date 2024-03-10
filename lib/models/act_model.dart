import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ActModel {
  final String month;
   final String cc;
    final String cc1;
  ActModel({
    required this.month,
    required this.cc,
    required this.cc1,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'month': month,
      'cc': cc,
      'cc1': cc1,
    };
  }

  factory ActModel.fromMap(Map<String, dynamic> map) {
    return ActModel(
      month: (map['month'] ?? '') as String,
      cc: (map['cc'] ?? '') as String,
      cc1: (map['cc1'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActModel.fromJson(String source) => ActModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
