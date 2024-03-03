// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MemberModel {
  final String cid;
  final String name;
  final String lastname;
  final String address;
  final String phone;
  final String images;
  final String lat;
  final String lng;
  final String? token;
  MemberModel({
    required this.cid,
    required this.name,
    required this.lastname,
    required this.address,
    required this.phone,
    required this.images,
    required this.lat,
    required this.lng,
    this.token,
  });
  

 

  MemberModel copyWith({
    String? cid,
    String? name,
    String? lastname,
    String? address,
    String? phone,
    String? images,
    String? lat,
    String? lng,
    String? token,
  }) {
    return MemberModel(
      cid: cid ?? this.cid,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      images: images ?? this.images,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'name': name,
      'lastname': lastname,
      'address': address,
      'phone': phone,
      'images': images,
      'lat': lat,
      'lng': lng,
      'token': token,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      cid: (map['cid'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      lastname: (map['lastname'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      images: (map['images'] ?? '') as String,
      lat: (map['lat'] ?? '') as String,
      lng: (map['lng'] ?? '') as String,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) => MemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MemberModel(cid: $cid, name: $name, lastname: $lastname, address: $address, phone: $phone, images: $images, lat: $lat, lng: $lng, token: $token)';
  }

  @override
  bool operator ==(covariant MemberModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.cid == cid &&
      other.name == name &&
      other.lastname == lastname &&
      other.address == address &&
      other.phone == phone &&
      other.images == images &&
      other.lat == lat &&
      other.lng == lng &&
      other.token == token;
  }

  @override
  int get hashCode {
    return cid.hashCode ^
      name.hashCode ^
      lastname.hashCode ^
      address.hashCode ^
      phone.hashCode ^
      images.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      token.hashCode;
  }
}
