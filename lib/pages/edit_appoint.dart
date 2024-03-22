// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruksa/models/appointment_model.dart';
import 'package:pruksa/models/member_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';

class editAppoint extends StatefulWidget {
  final AppointModel appointModels;
  const editAppoint({Key? key, required this.appointModels}) : super(key: key);

  @override
  State<editAppoint> createState() => _editAppointState();
}

class _editAppointState extends State<editAppoint> {
  AppointModel? appointModels;
  final formKey = GlobalKey<FormState>();
  List groupList = [];
  String? selecteValue;
  void initState() {
    // TODO: implement initState
    super.initState();
    appointModels = widget.appointModels;

    // print('### image from mySQL ==>> ${productModel!.images}');

    loadActivegroupFromAPI();
  }

  Future<Null> loadActivegroupFromAPI() async {
    String apiGetActiveGroup = '${MyConstant.domain}/dopa/api/getstatus.php';
    await Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    //print(poslist);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการจองบัตรคิว'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  'ข้อมูลผู้จองคิว',
                  style: MyConstant().h1blackStyle(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'ผู้ร้อง:${appointModels!.name}',
                  style: MyConstant().gh2Style(),
                ),
                Text('เลชบัตรประชาขน:${appointModels!.cid} ',
                    style: MyConstant().gh2Style()),
                Text('รายละเอียด:${appointModels!.detail} ',
                    style: MyConstant().gh2Style()),
                SizedBox(
                  height: 10.0,
                ),
                Text('แผนก:${appointModels!.sub_name}',
                    style: MyConstant().gh2Style()),
                Text(
                  'วันที่:${appointModels!.app_date} เวลา ${appointModels!.app_time}',
                  style: MyConstant().gh2Style(),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'สถานะ',
                      style: MyConstant().h2RedStyle(),
                    ),
                    buildGroup(constraints),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      processEdit();
                    }
                  },
                  child: Text(
                    'อับเดทข้อมูล',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: MyConstant().mygreenbutton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
    Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String id = appointModels!.app_key;
      String cid = appointModels!.cid;

      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/edit_appoint.php?isUpdate=true&id=$id&status=$selecteValue';
      await Dio().get(apiEditProduct).then((value) {
        Get.back();
        if (value.toString() == 'true') {
          print('value is Success');
          sendnotitomember(cid);
        } else {
          print('false');
        }
      });
    }
  }

  Future<Null> sendnotitomember(String cid) async {
    print('cids = $cid');
    String findtoken =
        '${MyConstant.domain}/dopa/api/getcidtoken.php?isAdd=true&cid=$cid';
    await Dio().get(findtoken).then((value) {
      //print('value is $value');
      var results = jsonDecode(value.data);
      print('reult == $results');
      for (var element in results) {
        MemberModel model = MemberModel.fromMap(element);
        String? tokens = model.token;
        print('token is $tokens');
        String titel = 'ข้อมูลคำขอของท่านการมีการอับเดท';
        String body = 'กรุณาดูข้อมูลที่เมนูจองคิวด้วยค่ะ ';

        String sendtoken =
            '${MyConstant.domain}/dopa/api/apinoti.php?isAdd=true&title=$titel&body=$body&token=$tokens';

        sendfcmtomember(sendtoken);
      }
    });
  }

  Future<Null> sendfcmtomember(String sendtoken) async {
    await Dio().get(sendtoken).then((value) => Navigator.pop(context));
  }

  Widget buildGroup(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุประเภท'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: groupList.map((pos) {
            return DropdownMenuItem(
                value: pos['status_id'], child: Text(pos['status_name']));
            // print(pos['active_id']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              selecteValue = value as String;

              // print(selecteValue);
            });
          }),
    );
  }
}
