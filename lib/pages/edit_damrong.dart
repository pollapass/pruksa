import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruksa/models/damrong_model.dart';
import 'package:pruksa/models/member_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDamrong extends StatefulWidget {
  final DamrongModels dammodels;
  const EditDamrong({Key? key, required this.dammodels}) : super(key: key);

  @override
  State<EditDamrong> createState() => _EditDamrongState();
}

class _EditDamrongState extends State<EditDamrong> {
  DamrongModels? dammodels;
  List groupList = [];
  String? selecteValue;

  TextEditingController remarkController = TextEditingController();
  List<String> pathImages = [];

  bool statusImage = false;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dammodels = widget.dammodels;
    remarkController.text = dammodels!.contact_remark!;
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
        title: Text('ข้อมูลการร้องเรียน'),
      ),
      body: LayoutBuilder(
          builder: (context, constraints) => Center(
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusScopeNode()),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ข้อมูลทั่วไป',
                                style: MyConstant().h1blackStyle(),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('ผู้ร้อง:${dammodels!.fullname} '),
                              Text('เลชบัตรประชาขน:${dammodels!.cid} '),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                  'เรื่องร้องเรียน:${dammodels!.contact_detail} '),
                              Text('รายละเอีดย:${dammodels!.contact_detail} '),
                              SizedBox(
                                height: 10.0,
                              ),
                              ShowTitle(
                                  title: 'ภาพถ่าย:',
                                  textStyle: MyConstant().h2Style()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 16),
                                    width: constraints.maxWidth * 0.6,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${MyConstant.domain}/images/damrong/${dammodels!.contact_images}',
                                      placeholder: (context, url) =>
                                          ShowProgress(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              ShowTitle(
                                  title: 'สำหรับเจ้าหน้าที่ :',
                                  textStyle: MyConstant().h2Style()),
                              SizedBox(
                                height: 10.0,
                              ),
                              Buildremark(constraints),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('สถานะ'),
                                  buildGroup(constraints),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossFadeState,
                                  children: [
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
                ),
              )),
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

  Future<Null> processdel() async {
    MyDialog().showProgressDialog(context);

    String id = dammodels!.contact_key;
    print('###key =$id');
    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/deldamrong.php?isDelete=true&id=$id';
                
    await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    Navigator.pop(context);
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String remark = remarkController.text;
      SharedPreferences preference = await SharedPreferences.getInstance();
      String userkey = preference.getString('id')!;

      print('### key = $userkey');
      String id = dammodels!.contact_key;
      String cid = dammodels!.cid;

      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/edit_damrong.php?isUpdate=true&id=$id&remark=$remark&status=$selecteValue&userkey=$userkey';
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
        String body = 'กรุณาดูข้อมูลที่เมนูเรื่องร้องเรียนด้วยค่ะด้วยค่ะ ';

        String sendtoken =
            '${MyConstant.domain}/dopa/api/apinoti.php?isAdd=true&title=$titel&body=$body&token=$tokens';

        sendfcmtomember(sendtoken);
      }
    });
  }

  Future<Null> sendfcmtomember(String sendtoken) async {
    await Dio().get(sendtoken).then((value) => Navigator.pop(context));
  }

  Row Buildremark(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            maxLines: 4,
            controller: remarkController,
            decoration: InputDecoration(
              labelText: 'รายละเอียดการแก้ไข :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
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
