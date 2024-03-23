import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/pab/member_report.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class dopalist extends StatefulWidget {
  const dopalist({Key? key}) : super(key: key);

  @override
  State<dopalist> createState() => _dopalistState();
}

class _dopalistState extends State<dopalist> {
   bool load = true;
  bool? haveData;
  List<UserModel> usermodels = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadmemberfromapi();
    // initialFile();
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
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(
          'ข้อมูลฝ่ายปกครอง',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: MyConstant.primary,
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? Container(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: usermodels.length,
                      itemBuilder: (context, index) => Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(242, 244, 247, 0.898)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MemberReport(
                                          userModels: usermodels[index],
                                        ),
                                      )).then((value) => loadmemberfromapi());
                                },
                                trailing: Icon(Icons.keyboard_arrow_right,
                                    color: Color.fromARGB(255, 22, 22, 22),
                                    size: 30.0),
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
                                            color: Color.fromARGB(
                                                255, 28, 28, 28))),
                                  ],
                                ),
                              ),
                            ),
                          )
                      //
                      ),
                )
              : Column(
                  children: [
                    ShowTitle(
                      title: 'ไม่มีข้อมูล',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                    ShowTitle(
                      title: 'ไม่มีฝ่ายปกครองในระบบ',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),
    );
  }
}