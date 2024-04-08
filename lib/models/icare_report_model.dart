import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class icareReport {
 final String report_key;
  final String cid;
  final String titel;
  final String report_date;
  final String report_images;
  final String report_detail;
  final String fullname;
  final String address;
  final String moopart;
  final String fulladdress;
  final String income_name;
  final String username;
  final String dep_name;
 
  final String pos_name;
  icareReport({
    required this.report_key,
    required this.cid,
    required this.titel,
    required this.report_date,
    required this.report_images,
    required this.report_detail,
    required this.fullname,
    required this.address,
    required this.moopart,
    required this.fulladdress,
    required this.income_name,
    required this.username,
    required this.dep_name,
    required this.pos_name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'report_key': report_key,
      'cid': cid,
      'titel': titel,
      'report_date': report_date,
      'report_images': report_images,
      'report_detail': report_detail,
      'fullname': fullname,
      'address': address,
      'moopart': moopart,
      'fulladdress': fulladdress,
      'income_name': income_name,
      'username': username,
      'dep_name': dep_name,
      'pos_name': pos_name,
    };
  }

  factory icareReport.fromMap(Map<String, dynamic> map) {
    return icareReport(
      report_key: (map['report_key'] ?? '') as String,
      cid: (map['cid'] ?? '') as String,
      titel: (map['titel'] ?? '') as String,
      report_date: (map['report_date'] ?? '') as String,
      report_images: (map['report_images'] ?? '') as String,
      report_detail: (map['report_detail'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      moopart: (map['moopart'] ?? '') as String,
      fulladdress: (map['fulladdress'] ?? '') as String,
      income_name: (map['income_name'] ?? '') as String,
      username: (map['username'] ?? '') as String,
      dep_name: (map['dep_name'] ?? '') as String,
      pos_name: (map['pos_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory icareReport.fromJson(String source) => icareReport.fromMap(json.decode(source) as Map<String, dynamic>);
}
