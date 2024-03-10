import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pruksa/models/member_model.dart';

import 'package:pruksa/models/redcross_model.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class editredcross extends StatefulWidget {
  final RedcrossModel redcrossmodels;
  const editredcross({Key? key, required this.redcrossmodels})
      : super(key: key);

  @override
  State<editredcross> createState() => _editredcrossState();
}

class _editredcrossState extends State<editredcross> {
  RedcrossModel? redcrossmodels;
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
    redcrossmodels = widget.redcrossmodels;
    remarkController.text = redcrossmodels!.remark;
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
          title: Text('ข้อมูลขอรับความช่วยเหลือ'),
        ),
        body: Card(
          elevation: 10.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
          // margin: EdgeInsets.all(15),
           padding: EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: Color.fromRGBO(246, 242, 247, 0.894)),
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusScopeNode()),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ข้อมูลทั่วไป',
                            style: MyConstant().h1blackStyle(),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'ขื่อ:${redcrossmodels!.name} ${redcrossmodels!.lastname}',
                            style: MyConstant().h2Blacktyle(),
                          ),
                          Text('เลชบัตรประชาขน:${redcrossmodels!.cid}  '),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text('เรื่องร้องเรียน:${redcrossmodels!.help_name} '),
                          ShowTitle(
                              title: 'ภาพถ่าย:',
                              textStyle: MyConstant().h2Style()),
                          Buildpicture(),
                          SizedBox(
                            height: 10.0,
                          ),
                          ShowTitle(
                              title: 'Location :',
                              textStyle: MyConstant().h2Style()),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                width: 300,
                                height: 300,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      double.parse('${redcrossmodels!.lat}'),
                                      double.parse('${redcrossmodels!.lng}'),
                                    ),
                                    zoom: 16,
                                  ),
                                  markers: <Marker>{
                                    Marker(
                                        markerId: MarkerId('id'),
                                        onTap: () {
                                          print('#### tap marker');
                                          Appservice().gotodirection(
                                              lat: redcrossmodels!.lat!,
                                              lng: redcrossmodels!.lng!);
                                        },
                                        position: LatLng(
                                          double.parse(
                                              '${redcrossmodels!.lat}'),
                                          double.parse(
                                              '${redcrossmodels!.lng}'),
                                        ),
                                        infoWindow: InfoWindow(
                                            title: 'เป็าหมายอยู่ที่นี่ ',
                                            snippet:
                                                'lat = ${redcrossmodels!.lat}, lng = ${redcrossmodels!.lng}')),
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ShowTitle(
                              title: 'สำหรับเจ้าหน้าที่ :',
                              textStyle: MyConstant().h2Style()),
                          Buildremark(constraints),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('สถานะ'),
                              buildGroup(constraints),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
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
          ),
        ));
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

    String id = redcrossmodels!.red_id;
    print('###key =$id');
    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/del_redcross.php?isDelete=true&id=$id';

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
      String id = redcrossmodels!.red_id;
      String cid = redcrossmodels!.cid;

      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/edit_redcross.php?isUpdate=true&id=$id&remark=$remark&status=$selecteValue&userkey=$userkey';
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
        String body = 'กรุณาดูข้อมูลที่เมนูกาชาดด้วยค่ะ';

        String sendtoken =
            '${MyConstant.domain}/dopa/api/apinoti.php?isAdd=true&title=$titel&body=$body&token=$tokens';

        sendfcmtomember(sendtoken);
      }
    });
  }

  Future<Null> sendfcmtomember(String sendtoken) async {
    await Dio().get(sendtoken).then((value) => Navigator.pop(context));
  }

  Row Buildpicture() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: 300,
          height: 300,
          child: CachedNetworkImage(
            imageUrl:
                '${MyConstant.domain}/images/redcross/${redcrossmodels!.images}',
            placeholder: (context, url) => ShowProgress(),
          ),
        ),
      ],
    );
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
