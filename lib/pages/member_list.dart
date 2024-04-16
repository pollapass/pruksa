// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:url_launcher/url_launcher.dart';

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

    // initialFile();
  }

  Future<Null> getUserDetails() async {
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getphoneuser.php?isAdd=true';
    final response = await Dio().get(apigetmemberlist);
    final responseJson = json.decode(response.data);

    setState(() {
      for (Map<String, dynamic> user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
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
      if (userDetail.fullname.contains(text) ||
          userDetail.pos_name.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหาเบอร์โทรศีพท์'),
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

  Padding BuildTitel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: titelController,
            decoration: new InputDecoration(
                hintText: 'ค้นหา', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              titelController.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  Expanded Buildmember() {
    return Expanded(
      child: _searchResult.length != 0 || titelController.text.isNotEmpty
          ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(
                  child: new ListTile(
                    onTap: () async {
                      Uri phoneno =
                          Uri.parse('tel:${_searchResult[i].user_phone}');
                      if (await launchUrl(phoneno)) {
                        //dialer opened
                      } else {
                        //dailer is not opened
                      }
                    },
                    trailing: Icon(Icons.phone,
                        color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
                    leading: new CircleAvatar(
                      backgroundImage: new NetworkImage(
                        ('${MyConstant.domain}/dopa/resource/users/images/${_searchResult[i].user_photo}'),
                      ),
                    ),
                    title: new Text(_searchResult[i].fullname +
                        ' ' +
                        _searchResult[i].pos_name),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
          : new ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return new Card(
                  child: new ListTile(
                    onTap: () async {
                      Uri phoneno =
                          Uri.parse('tel:${_userDetails[index].user_phone}');
                      if (await launchUrl(phoneno)) {
                        //dialer opened
                      } else {
                        //dailer is not opened
                      }
                    },
                    trailing: Icon(Icons.phone,
                        color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
                    leading: new CircleAvatar(
                      backgroundImage: new NetworkImage(
                        ('${MyConstant.domain}/dopa/resource/users/images/${_userDetails[index].user_photo}'),
                      ),
                    ),
                    title: new Text(_userDetails[index].fullname +
                        ' ' +
                        _userDetails[index].pos_name),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
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
