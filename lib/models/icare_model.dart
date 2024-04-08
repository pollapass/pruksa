import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class icaremodel {
  final String fullname;
  final String cid;
  final String? birthdate;
  final String id;
  final String moopart;
  final String address;
  final String tmbpart;
  final String amppart;
  final String chwpart;
  final String address_id;
  final String detail;
  final String icare_type;
  final String? enddate;
  final String status;
  final String icare_photo;
  final String? mobile;
  final String? request;
  final String type_id;
  final String type_name;
  icaremodel({
    required this.fullname,
    required this.cid,
    this.birthdate,
    required this.id,
    required this.moopart,
    required this.address,
    required this.tmbpart,
    required this.amppart,
    required this.chwpart,
    required this.address_id,
    required this.detail,
    required this.icare_type,
    this.enddate,
    required this.status,
    required this.icare_photo,
    this.mobile,
    this.request,
    required this.type_id,
    required this.type_name,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'cid': cid,
      'birthdate': birthdate,
      'id': id,
      'moopart': moopart,
      'address': address,
      'tmbpart': tmbpart,
      'amppart': amppart,
      'chwpart': chwpart,
      'address_id': address_id,
      'detail': detail,
      'icare_type': icare_type,
      'enddate': enddate,
      'status': status,
      'icare_photo': icare_photo,
      'mobile': mobile,
      'request': request,
      'type_id': type_id,
      'type_name': type_name,
    };
  }

  factory icaremodel.fromMap(Map<String, dynamic> map) {
    return icaremodel(
      fullname: (map['fullname'] ?? '') as String,
      cid: (map['cid'] ?? '') as String,
      birthdate: map['birthdate'] != null ? map['birthdate'] as String : null,
      id: (map['id'] ?? '') as String,
      moopart: (map['moopart'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      tmbpart: (map['tmbpart'] ?? '') as String,
      amppart: (map['amppart'] ?? '') as String,
      chwpart: (map['chwpart'] ?? '') as String,
      address_id: (map['address_id'] ?? '') as String,
      detail: (map['detail'] ?? '') as String,
      icare_type: (map['icare_type'] ?? '') as String,
      enddate: map['enddate'] != null ? map['enddate'] as String : null,
      status: (map['status'] ?? '') as String,
      icare_photo: (map['icare_photo'] ?? '') as String,
      mobile: map['mobile'] != null ? map['mobile'] as String : null,
      request: map['request'] != null ? map['request'] as String : null,
      type_id: (map['type_id'] ?? '') as String,
      type_name: (map['type_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory icaremodel.fromJson(String source) => icaremodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
