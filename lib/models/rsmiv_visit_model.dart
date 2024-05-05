import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class reportsmivvisitmodel {
  final String sm_name;
  final String? cid;
  final String address;
  final String moopart;
  final String visit_key;
  final String sm_key;
  final String visit_date;
  final String drug;
  final String relative;
  final String addic;
  final String insert_user;
  final String? note;
  final String send;
  final String? level_name;
  final String? fullname;
  final String fulladdress;
  reportsmivvisitmodel({
    required this.sm_name,
    this.cid,
    required this.address,
    required this.moopart,
    required this.visit_key,
    required this.sm_key,
    required this.visit_date,
    required this.drug,
    required this.relative,
    required this.addic,
    required this.insert_user,
    this.note,
    required this.send,
    this.level_name,
    this.fullname,
    required this.fulladdress,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sm_name': sm_name,
      'cid': cid,
      'address': address,
      'moopart': moopart,
      'visit_key': visit_key,
      'sm_key': sm_key,
      'visit_date': visit_date,
      'drug': drug,
      'relative': relative,
      'addic': addic,
      'insert_user': insert_user,
      'note': note,
      'send': send,
      'level_name': level_name,
      'fullname': fullname,
      'fulladdress': fulladdress,
    };
  }

  factory reportsmivvisitmodel.fromMap(Map<String, dynamic> map) {
    return reportsmivvisitmodel(
      sm_name: (map['sm_name'] ?? '') as String,
      cid: map['cid'] != null ? map['cid'] as String : null,
      address: (map['address'] ?? '') as String,
      moopart: (map['moopart'] ?? '') as String,
      visit_key: (map['visit_key'] ?? '') as String,
      sm_key: (map['sm_key'] ?? '') as String,
      visit_date: (map['visit_date'] ?? '') as String,
      drug: (map['drug'] ?? '') as String,
      relative: (map['relative'] ?? '') as String,
      addic: (map['addic'] ?? '') as String,
      insert_user: (map['insert_user'] ?? '') as String,
      note: map['note'] != null ? map['note'] as String : null,
      send: (map['send'] ?? '') as String,
      level_name: map['level_name'] != null ? map['level_name'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      fulladdress: (map['fulladdress'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory reportsmivvisitmodel.fromJson(String source) => reportsmivvisitmodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
