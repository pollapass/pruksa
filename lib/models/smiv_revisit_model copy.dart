import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class smivrevisitmodel {
    final String visit_id;
  final String sm_key;
  final String visit_date;
  final String mental;
  final String med;
  final String relat;
  final String prac;
  final String occu;
   final String rela;
   final String en;
   final String com;
   final String edu;
   final String drug;
   final String user_key;
   final String note;
   final String confirm;
   final String? images;
   final String? fullname;
   final String? total;
  smivrevisitmodel({
    required this.visit_id,
    required this.sm_key,
    required this.visit_date,
    required this.mental,
    required this.med,
    required this.relat,
    required this.prac,
    required this.occu,
    required this.rela,
    required this.en,
    required this.com,
    required this.edu,
    required this.drug,
    required this.user_key,
    required this.note,
    required this.confirm,
    this.images,
    this.fullname,
    this.total,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'visit_id': visit_id,
      'sm_key': sm_key,
      'visit_date': visit_date,
      'mental': mental,
      'med': med,
      'relat': relat,
      'prac': prac,
      'occu': occu,
      'rela': rela,
      'en': en,
      'com': com,
      'edu': edu,
      'drug': drug,
      'user_key': user_key,
      'note': note,
      'confirm': confirm,
      'images': images,
      'fullname': fullname,
      'total': total,
    };
  }

  factory smivrevisitmodel.fromMap(Map<String, dynamic> map) {
    return smivrevisitmodel(
      visit_id: (map['visit_id'] ?? '') as String,
      sm_key: (map['sm_key'] ?? '') as String,
      visit_date: (map['visit_date'] ?? '') as String,
      mental: (map['mental'] ?? '') as String,
      med: (map['med'] ?? '') as String,
      relat: (map['relat'] ?? '') as String,
      prac: (map['prac'] ?? '') as String,
      occu: (map['occu'] ?? '') as String,
      rela: (map['rela'] ?? '') as String,
      en: (map['en'] ?? '') as String,
      com: (map['com'] ?? '') as String,
      edu: (map['edu'] ?? '') as String,
      drug: (map['drug'] ?? '') as String,
      user_key: (map['user_key'] ?? '') as String,
      note: (map['note'] ?? '') as String,
      confirm: (map['confirm'] ?? '') as String,
      images: map['images'] != null ? map['images'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      total: map['total'] != null ? map['total'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory smivrevisitmodel.fromJson(String source) => smivrevisitmodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
