import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/activedetail_model.dart';
import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/pab/user_post.dart';
import 'package:pruksa/utility/my_constant.dart';

class activeMain extends StatefulWidget {
  const activeMain({Key? key}) : super(key: key);

  @override
  State<activeMain> createState() => _activeMainState();
}

class _activeMainState extends State<activeMain> {
  bool load = true;

  bool? haveData;
  List<UserModel> usermodels = [];
  List<ActiveDetailModel> itemList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // loadmemberfromapi();
    loadvaluefromapi();

    // initialFile();
  }


  Future<Null> loadvaluefromapi() async {
    if (itemList.length != 0) {
      itemList.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getactive.php?isAdd=true';
    await Dio().get(apigetactivelist).then((value) {
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
          // ActiveListModel model = ActiveListModel.fromMap(item);
          //print('name of titel =${model.titel}');
          ActiveDetailModel model = ActiveDetailModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            itemList.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบปกครองท้องที่ อำเภอบ้านหลวง'), actions: [],
        // backgroundColor: Color(0xFFEDF0F6),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(

                //itemCount: stories.length + 1,
                itemCount: itemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return UserPost(
                      name: itemList[index].fullname,
                      detail: itemList[index].act_detail,
                      act_date: itemList[index].act_date,
                      itemsname: itemList[index].items_name,
                      user_key: itemList[index].user_key,
                      user_photo:
                          '${MyConstant.domain}/dopa/resource/users/images/${itemList[index].user_photo}',
                      photo:
                          '${MyConstant.domain}/dopa/resource/active/images/${itemList[index].act_images}',
                      titel: itemList[index].titel,
                      act_key: itemList[index].act_key);
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
     onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeAddactive)
              .then((value) => loadvaluefromapi());
        },
        child: Text('เพิ่ม'),
      ),
    );
  }
}
