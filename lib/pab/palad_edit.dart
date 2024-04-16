import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:pruksa/models/act_report_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_progress.dart';

class paladedit extends StatefulWidget {
  final String activekey;
  final String name;
  const paladedit({
    Key? key,
    required this.activekey,
    required this.name,
  }) : super(key: key);

  @override
  State<paladedit> createState() => _paladeditState();
}

class _paladeditState extends State<paladedit> {
  actreport? areportModel;
  TextEditingController titelController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List groupList = [];
  List itemList = [];
  String? selecteValue;
  String? selectitems;
  final formKey = GlobalKey<FormState>();
  File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    loadgroupFromAPI();
    loaditemFromAPI();
    //findLatLng();
  }

  Future<Null> findUser() async {
    String apiGetUser =
        '${MyConstant.domain}/dopa/api/getActivereportWherekey.php?isAdd=true&id=${widget.activekey}';
    await Dio().get(apiGetUser).then((value) {
      // print('value from API ==>> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          areportModel = actreport.fromMap(item);
        });
      }
    });
  }

  Future<Null> loadgroupFromAPI() async {
    print('group is ${areportModel!.act_group}');
    String apiGetActiveGroup =
        '${MyConstant.domain}/dopa/api/getactgroupwhere.php?isAdd=true&id=${areportModel!.act_group}';
    await Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    //print(poslist);
  }

  Future<Null> loaditemFromAPI() async {
    print('irems is ${areportModel!.act_group}');
    String apiGetActiveGroup =
        '${MyConstant.domain}/dopa/api/getactitemswhere.php?isAdd=true&id=${areportModel!.act_items}';
    await Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        itemList = item;
      });
    });
    //print(poslist);
  }

  Future<Null> loadActivegroupFromAPI() async {
    String apiGetActiveGroup = '${MyConstant.domain}/dopa/api/getactgroup.php';
    await Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    //print(poslist);
  }

  Future<Null> _getActiveList() async {
    String? id = selecteValue;
    String apiGetActiveList =
        '${MyConstant.domain}/dopa/api/getactlist.php?isAdd=true&id=$id ';
    await Dio().get(apiGetActiveList).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);
      setState(() {
        itemList = item;
      });
    });
    //print(poslist);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: Card(
              color: Colors.white70,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  //BuildDetail(),
                  Text('วันที่  ${areportModel!.act_date} '),
                  SizedBox(
                    height: 10,
                  ),
                  Text('เรื่อง  ${areportModel!.titel} '),
                  SizedBox(
                    height: 10,
                  ),
                  Text('รายละเอียด ${areportModel!.act_detail} '),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'รูปภาพ',
                    style: MyConstant().gh2Style(),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                        '${MyConstant.domain}/dopa/resource/active/images/${areportModel!.act_images}'),
                  ),
                  //buildAvatar(constraints),
                  SizedBox(
                    height: 20,
                  ),
                  buildGroup(constraints),
                  SizedBox(
                    height: 20,
                  ),
                  buildGroupList(constraints),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossFadeState,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // processEdit();
                          },
                          child: Text(
                            'อับเดทข้อมูล',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: MyConstant().mygreenbutton(),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        ElevatedButton(
                          onPressed: () {
                            _dialogBuilder(context);
                          },
                          child: Text(
                            'ลบข้อมูล',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: MyConstant().myredbutton(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGroup(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          //hint: Text('กรุณาระบุประเภท'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: groupList.map((pos) {
            return DropdownMenuItem(
                value: pos['active_id'], child: Text(pos['active_name']));
            // print(pos['active_id']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              loadActivegroupFromAPI();
              selectitems = null;
              selecteValue = value as String;
              _getActiveList();
              // print(selecteValue);
            });
          }),
    );
  }

  Widget buildGroupList(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          //hint: Text('กรุณาระบุรายการ'),
          value: selectitems,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: itemList.map((code) {
            return DropdownMenuItem(
                value: code['items_code'], child: Text(code['items_name']));
            //print(pos['items_name']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectitems = value as String;

              // print(selectitems);
            });
          }),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบข้อมูล'),
          content: const Text(
            'หากกดปุ่มยืนยันแล้วข้อมูลจะถูกลบจากฐานข้อมูล ไม่สามารถกู้ข้อมูลได้',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยืนยัน'),
              onPressed: () {
                processdel();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> processdel() async {
    MyDialog().showProgressDialog(context);

    String id = widget!.activekey;
    print(' id - $id');

    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/del_active.php?isDelete=true&id=$id';
    await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    Navigator.pop(context);
  }
}
