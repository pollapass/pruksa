import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class smivmodel {
  final String sm_key;
  final String sm_name;
  final String? cid;
  final String report_date;
  final String mobile;
  final String address;
  final String moopart;
  final String tmbpart;
  final String chwpart;
  final String? remark;
  final String? lat;
  final String? lng;
  final String insert_user;
  final String confirm;
  final String items_name;
  final String? confrm_user;
  final String sleep;
  final String warlk;
  final String speak;
  final String feel;
  final String fear;
  final String sm_level;
  final String? sm_image;
  final String status_name;
  final String level_name;
  final String? fullname;
  final String? fulladdress;
  smivmodel({
    required this.sm_key,
    required this.sm_name,
    this.cid,
    required this.report_date,
    required this.mobile,
    required this.address,
    required this.moopart,
    required this.tmbpart,
    required this.chwpart,
    this.remark,
    this.lat,
    this.lng,
    required this.insert_user,
    required this.confirm,
    required this.items_name,
    this.confrm_user,
    required this.sleep,
    required this.warlk,
    required this.speak,
    required this.feel,
    required this.fear,
    required this.sm_level,
    this.sm_image,
    required this.status_name,
    required this.level_name,
    this.fullname,
    this.fulladdress,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sm_key': sm_key,
      'sm_name': sm_name,
      'cid': cid,
      'report_date': report_date,
      'mobile': mobile,
      'address': address,
      'moopart': moopart,
      'tmbpart': tmbpart,
      'chwpart': chwpart,
      'remark': remark,
      'lat': lat,
      'lng': lng,
      'insert_user': insert_user,
      'confirm': confirm,
      'items_name': items_name,
      'confrm_user': confrm_user,
      'sleep': sleep,
      'warlk': warlk,
      'speak': speak,
      'feel': feel,
      'fear': fear,
      'sm_level': sm_level,
      'sm_image': sm_image,
      'status_name': status_name,
      'level_name': level_name,
      'fullname': fullname,
      'fulladdress': fulladdress,
    };
  }

  factory smivmodel.fromMap(Map<String, dynamic> map) {
    return smivmodel(
      sm_key: (map['sm_key'] ?? '') as String,
      sm_name: (map['sm_name'] ?? '') as String,
      cid: map['cid'] != null ? map['cid'] as String : null,
      report_date: (map['report_date'] ?? '') as String,
      mobile: (map['mobile'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      moopart: (map['moopart'] ?? '') as String,
      tmbpart: (map['tmbpart'] ?? '') as String,
      chwpart: (map['chwpart'] ?? '') as String,
      remark: map['remark'] != null ? map['remark'] as String : null,
      lat: map['lat'] != null ? map['lat'] as String : null,
      lng: map['lng'] != null ? map['lng'] as String : null,
      insert_user: (map['insert_user'] ?? '') as String,
      confirm: (map['confirm'] ?? '') as String,
      items_name: (map['items_name'] ?? '') as String,
      confrm_user: map['confrm_user'] != null ? map['confrm_user'] as String : null,
      sleep: (map['sleep'] ?? '') as String,
      warlk: (map['warlk'] ?? '') as String,
      speak: (map['speak'] ?? '') as String,
      feel: (map['feel'] ?? '') as String,
      fear: (map['fear'] ?? '') as String,
      sm_level: (map['sm_level'] ?? '') as String,
      sm_image: map['sm_image'] != null ? map['sm_image'] as String : null,
      status_name: (map['status_name'] ?? '') as String,
      level_name: (map['level_name'] ?? '') as String,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      fulladdress: map['fulladdress'] != null ? map['fulladdress'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory smivmodel.fromJson(String source) => smivmodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
