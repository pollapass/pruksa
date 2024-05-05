import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class smvisitmodel {
  final String visit_key;
  final String sm_key;
  final String visit_date;
  final String drug;
  final String relative;
  final String addic;
  final String insert_user;
  final String note;
   final String fullname;
  smvisitmodel({
    required this.visit_key,
    required this.sm_key,
    required this.visit_date,
    required this.drug,
    required this.relative,
    required this.addic,
    required this.insert_user,
    required this.note,
    required this.fullname,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'visit_key': visit_key,
      'sm_key': sm_key,
      'visit_date': visit_date,
      'drug': drug,
      'relative': relative,
      'addic': addic,
      'insert_user': insert_user,
      'note': note,
      'fullname': fullname,
    };
  }

  factory smvisitmodel.fromMap(Map<String, dynamic> map) {
    return smvisitmodel(
      visit_key: (map['visit_key'] ?? '') as String,
      sm_key: (map['sm_key'] ?? '') as String,
      visit_date: (map['visit_date'] ?? '') as String,
      drug: (map['drug'] ?? '') as String,
      relative: (map['relative'] ?? '') as String,
      addic: (map['addic'] ?? '') as String,
      insert_user: (map['insert_user'] ?? '') as String,
      note: (map['note'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory smvisitmodel.fromJson(String source) => smvisitmodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
