// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FaqModel {
  final String faq_id;
  final String question;
  final String answer;
  final String? user_key;
  //final String? fullname;
  final String faq_date;
  FaqModel({
    required this.faq_id,
    required this.question,
    required this.answer,
    this.user_key,
    required this.faq_date,
  });

  FaqModel copyWith({
    String? faq_id,
    String? question,
    String? answer,
    String? user_key,
    String? faq_date,
  }) {
    return FaqModel(
      faq_id: faq_id ?? this.faq_id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      user_key: user_key ?? this.user_key,
      faq_date: faq_date ?? this.faq_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'faq_id': faq_id,
      'question': question,
      'answer': answer,
      'user_key': user_key,
      'faq_date': faq_date,
    };
  }

  factory FaqModel.fromMap(Map<String, dynamic> map) {
    return FaqModel(
      faq_id: map['faq_id'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
      user_key: map['user_key'] != null ? map['user_key'] as String : null,
      faq_date: map['faq_date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqModel.fromJson(String source) => FaqModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FaqModel(faq_id: $faq_id, question: $question, answer: $answer, user_key: $user_key, faq_date: $faq_date)';
  }

  @override
  bool operator ==(covariant FaqModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.faq_id == faq_id &&
      other.question == question &&
      other.answer == answer &&
      other.user_key == user_key &&
      other.faq_date == faq_date;
  }

  @override
  int get hashCode {
    return faq_id.hashCode ^
      question.hashCode ^
      answer.hashCode ^
      user_key.hashCode ^
      faq_date.hashCode;
  }
}
