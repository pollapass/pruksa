// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:faker/faker.dart';

class User {
    final String fullname;
  final String ?user_key;
 final String? user_phone;
  final String user_photo;
  final String? name;
  final String? lastname;
  final String? user_position;
  final String pos_name;
  final String? token;
  User({
    required this.fullname,
     this.user_key,
    this.user_phone,
    required this.user_photo,
     this.name,
     this.lastname,
     this.user_position,
    required this.pos_name,
    this.token,
  });

  
}
class UserData {
  static final faker = Faker();
  static final List<User> users = List.generate(
      50,
      (index) => User(
            fullname: faker.person.name(),
            pos_name: faker.job.title(),
            user_photo: 'https://source.unsplash.com/random?user+face&sig=$index',  // เมื่อเริ่มต้น จะไปดึงรูปมา 50 รูปเลยเก็บไว้ก่อน สร้างเป็น List<User>
          ));

  static List<User> getSuggestions(String query) =>  // เมื่อได้รับ query เข้ามา ก็จะนำค่าแต่ละตัวมาเช็ค
      List.of(users).where((user) {
        final userLower = user.fullname.toLowerCase();  // เพราะต้องการเช็คกับ name เท่านั้นนะ
        final queryLower = query.toLowerCase();
        return userLower.contains(queryLower);  // เช็คโดยเอา query มาเช็คกับ name ใน user
      }).toList();

}