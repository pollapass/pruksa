import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class actreport {

      final String act_key;
  final String user_key;
  final String act_date;
  final String report_date;
  final String titel;
  final String act_detail;
  final String act_images;
   final String act_group;
  final String act_items;
   final String? act_status;
  final String? act_comment;
   final String? palad_key;
  final String? act_type;
  final String? fullname;
   final String active_name;
  final String items_name;
  actreport({
    required this.act_key,
    required this.user_key,
    required this.act_date,
    required this.report_date,
    required this.titel,
    required this.act_detail,
    required this.act_images,
    required this.act_group,
    required this.act_items,
    this.act_status,
    this.act_comment,
    this.palad_key,
    this.act_type,
    this.fullname,
    required this.active_name,
    required this.items_name,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'act_key': act_key,
      'user_key': user_key,
      'act_date': act_date,
      'report_date': report_date,
      'titel': titel,
      'act_detail': act_detail,
      'act_images': act_images,
      'act_group': act_group,
      'act_items': act_items,
      'act_status': act_status,
      'act_comment': act_comment,
      'palad_key': palad_key,
      'act_type': act_type,
      'fullname': fullname,
      'active_name': active_name,
      'items_name': items_name,
    };
  }

  factory actreport.fromMap(Map<String, dynamic> map) {
    return actreport(
      act_key: (map['act_key'] ?? '') as String,
      user_key: (map['user_key'] ?? '') as String,
      act_date: (map['act_date'] ?? '') as String,
      report_date: (map['report_date'] ?? '') as String,
      titel: (map['titel'] ?? '') as String,
      act_detail: (map['act_detail'] ?? '') as String,
      act_images: (map['act_images'] ?? '') as String,
      act_group: (map['act_group'] ?? '') as String,
      act_items: (map['act_items'] ?? '') as String,
      act_status: map['act_status'] != null ? map['act_status'] as String : null,
      act_comment: map['act_comment'] != null ? map['act_comment'] as String : null,
      palad_key: map['palad_key'] != null ? map['palad_key'] as String : null,
      act_type: map['act_type'] != null ? map['act_type'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      active_name: (map['active_name'] ?? '') as String,
      items_name: (map['items_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory actreport.fromJson(String source) => actreport.fromMap(json.decode(source) as Map<String, dynamic>);
}
