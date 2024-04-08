import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class forrest {
  final String report_date;
  final String fullname;
  final String mobile;
  final String? cid;

  final String address;
  final String moopart;

  final String tmbpart;
  final String chwpart;

  final String for_key;
  final String insert_user;
   final String images;
     final String fulladdress;
  forrest({
    required this.report_date,
    required this.fullname,
    required this.mobile,
    this.cid,
    required this.address,
    required this.moopart,
    required this.tmbpart,
    required this.chwpart,
    required this.for_key,
    required this.insert_user,
    required this.images,
    required this.fulladdress,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'report_date': report_date,
      'fullname': fullname,
      'mobile': mobile,
      'cid': cid,
      'address': address,
      'moopart': moopart,
      'tmbpart': tmbpart,
      'chwpart': chwpart,
      'for_key': for_key,
      'insert_user': insert_user,
      'images': images,
      'fulladdress': fulladdress,
    };
  }

  factory forrest.fromMap(Map<String, dynamic> map) {
    return forrest(
      report_date: (map['report_date'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
      mobile: (map['mobile'] ?? '') as String,
      cid: map['cid'] != null ? map['cid'] as String : null,
      address: (map['address'] ?? '') as String,
      moopart: (map['moopart'] ?? '') as String,
      tmbpart: (map['tmbpart'] ?? '') as String,
      chwpart: (map['chwpart'] ?? '') as String,
      for_key: (map['for_key'] ?? '') as String,
      insert_user: (map['insert_user'] ?? '') as String,
      images: (map['images'] ?? '') as String,
      fulladdress: (map['fulladdress'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory forrest.fromJson(String source) => forrest.fromMap(json.decode(source) as Map<String, dynamic>);
}
