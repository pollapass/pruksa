// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/utility/my_constant.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  bool load = true;
  bool? haveData;
  List<UserModel> usermodels = [];
 List<UserDetails> _searchResult = [];

  List<UserDetails> _userDetails = [];
  //List<Map<String,dynamic>> items = [];
  //List<Map<String,dynamic>> founduser = [];
  TextEditingController titelController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getUserDetails();
    loadmemberfromapi();
    // initialFile();
  }

  Future<Null> getUserDetails() async {
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getalluser.php?isAdd=true';
    final response = await Dio().get(apigetmemberlist);
    final responseJson = json.decode(response.data);

    setState(() {
      for (Map<String, dynamic> user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }

  Future<Null> loadmemberfromapi() async {
    if (usermodels.length != 0) {
      usermodels.clear();
    } else {}
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getalluser.php?isAdd=true';
    await Dio().get(apigetmemberlist).then((value) {
      //print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          print('name of titel =${model.fullname}');

          setState(() {
            load = false;
            haveData = true;
            usermodels.add(model);
          });
        }
      }
    });
  }
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.fullname.contains(text) || userDetail.pos_name.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมาชิกทั้งหมด'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          BuildTitel(),
          Buildmember()
        ],
      ),
    );
  }

  Container BuildTitel() {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.blueGrey, blurRadius: 5)],
      ),
      child: TextFormField(
        controller: titelController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อชื่อ';
          } else {
            return null;
          }
        },
         onChanged: onSearchTextChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกชื่อเรื่อง',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Expanded Buildmember() {
    return Expanded(
      child: Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: usermodels.length,
            itemBuilder: (context, index) => Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(242, 244, 247, 0.898)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      onTap: () {},
                      trailing: Icon(Icons.keyboard_arrow_right,
                          color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
                      leading: Container(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                ('${MyConstant.domain}/dopa/resource/users/images/${usermodels[index].user_photo}'))),
                      ),
                      title: Text(
                        '${usermodels[index].pos_name}'
                        ''
                        '${usermodels[index].fullname}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 7, 7, 7),
                            fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text(usermodels[index].user_phone),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.mobile_screen_share,
                              color: Color.fromARGB(255, 11, 11, 11)),
                          Text('${usermodels[index].pos_name}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 28, 28, 28))),
                        ],
                      ),
                    ),
                  ),
                )
            //
            ),
      ),
    );
  }
}

class UserDetails {
  final String fullname;
  final String user_key;
  final String? user_phone;
  final String user_photo;
  final String pos_name;
  UserDetails({
    required this.fullname,
    required this.user_key,
    this.user_phone,
    required this.user_photo,
    required this.pos_name,
  });
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      user_key: json['user_key'],
      fullname: json['fullname'],
      user_photo: json['user_photo'],
      pos_name: json['pos_name'],
      user_phone: json['user_phone'],
    );
  }
}
