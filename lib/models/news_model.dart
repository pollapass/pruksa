import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class NewsModel {
  final String news_key;
  final String news_name_th;
  final String news_description_th;
  final String news_cover;
  final String? news_name_en;
  final String? news_description_en;
  final String? user_key;
  final String? news_public;

  final String fullname;
  final String pos_name;
  final String dep_name;
  NewsModel({
    required this.news_key,
    required this.news_name_th,
    required this.news_description_th,
    required this.news_cover,
    this.news_name_en,
    this.news_description_en,
    this.user_key,
    this.news_public,
    required this.fullname,
    required this.pos_name,
    required this.dep_name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'news_key': news_key,
      'news_name_th': news_name_th,
      'news_description_th': news_description_th,
      'news_cover': news_cover,
      'news_name_en': news_name_en,
      'news_description_en': news_description_en,
      'user_key': user_key,
      'news_public': news_public,
      'fullname': fullname,
      'pos_name': pos_name,
      'dep_name': dep_name,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      news_key: (map['news_key'] ?? '') as String,
      news_name_th: (map['news_name_th'] ?? '') as String,
      news_description_th: (map['news_description_th'] ?? '') as String,
      news_cover: (map['news_cover'] ?? '') as String,
      news_name_en:
          map['news_name_en'] != null ? map['news_name_en'] as String : null,
      news_description_en: map['news_description_en'] != null
          ? map['news_description_en'] as String
          : null,
      user_key: map['user_key'] != null ? map['user_key'] as String : null,
      news_public:
          map['news_public'] != null ? map['news_public'] as String : null,
      fullname: (map['fullname'] ?? '') as String,
      pos_name: (map['pos_name'] ?? '') as String,
      dep_name: (map['dep_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
