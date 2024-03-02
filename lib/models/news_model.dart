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
  NewsModel({
    required this.news_key,
    required this.news_name_th,
    required this.news_description_th,
    required this.news_cover,
    this.news_name_en,
    this.news_description_en,
    this.user_key,
    this.news_public,
  });

  NewsModel copyWith({
    String? news_key,
    String? news_name_th,
    String? news_description_th,
    String? news_cover,
    String? news_name_en,
    String? news_description_en,
    String? user_key,
    String? news_public,
  }) {
    return NewsModel(
      news_key: news_key ?? this.news_key,
      news_name_th: news_name_th ?? this.news_name_th,
      news_description_th: news_description_th ?? this.news_description_th,
      news_cover: news_cover ?? this.news_cover,
      news_name_en: news_name_en ?? this.news_name_en,
      news_description_en: news_description_en ?? this.news_description_en,
      user_key: user_key ?? this.user_key,
      news_public: news_public ?? this.news_public,
    );
  }

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
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      news_key: map['news_key'] as String,
      news_name_th: map['news_name_th'] as String,
      news_description_th: map['news_description_th'] as String,
      news_cover: map['news_cover'] as String,
      news_name_en:
          map['news_name_en'] != null ? map['news_name_en'] as String : null,
      news_description_en: map['news_description_en'] != null
          ? map['news_description_en'] as String
          : null,
      user_key: map['user_key'] != null ? map['user_key'] as String : null,
      news_public:
          map['news_public'] != null ? map['news_public'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewsModel(news_key: $news_key, news_name_th: $news_name_th, news_description_th: $news_description_th, news_cover: $news_cover, news_name_en: $news_name_en, news_description_en: $news_description_en, user_key: $user_key, news_public: $news_public)';
  }

  @override
  bool operator ==(covariant NewsModel other) {
    if (identical(this, other)) return true;

    return other.news_key == news_key &&
        other.news_name_th == news_name_th &&
        other.news_description_th == news_description_th &&
        other.news_cover == news_cover &&
        other.news_name_en == news_name_en &&
        other.news_description_en == news_description_en &&
        other.user_key == user_key &&
        other.news_public == news_public;
  }

  @override
  int get hashCode {
    return news_key.hashCode ^
        news_name_th.hashCode ^
        news_description_th.hashCode ^
        news_cover.hashCode ^
        news_name_en.hashCode ^
        news_description_en.hashCode ^
        user_key.hashCode ^
        news_public.hashCode;
  }
}
