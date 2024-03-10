import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:pruksa/models/informrisk_model.dart';
import 'package:pruksa/models/member_model.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class EditInformRisk extends StatefulWidget {
  final InformriskModel Riskmodels;
  const EditInformRisk({Key? key, required this.Riskmodels}) : super(key: key);

  @override
  State<EditInformRisk> createState() => _EditInformRiskState();
}

class _EditInformRiskState extends State<EditInformRisk> {
  InformriskModel? Riskmodels;
  List groupList = [];
  String? selecteValue;
  TextEditingController titleController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  List<String> pathImages = [];
  List<File?> files = [];
  bool statusImage = false; // false => Not Change Image

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Riskmodels = widget.Riskmodels;
    // print('### image from mySQL ==>> ${productModel!.images}');
    nameController.text = Riskmodels!.inform_name;
    //titleController.text = Riskmodels!.inform_titel;
    placeController.text = Riskmodels!.inform_place;
    detailController.text = Riskmodels!.inform_detail;
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
        title: Text('ข้อมูลการแจ้งแหล่งมั่วสุ่ม'),
        backgroundColor: MyConstant.primary,
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
                            Buildname(constraints),
                            SizedBox(
                              height: 10.0,
                            ),
                            Builddetail(constraints),
                            SizedBox(
                              height: 10.0,
                            ),
                            ShowTitle(
                                title: 'ภาพถ่ายจุดเสี่ยง :',
                                textStyle: MyConstant().h2Style()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  width: constraints.maxWidth * 0.6,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${MyConstant.domain}/images/informrisk/${Riskmodels!.inform_images}',
                                    placeholder: (context, url) =>
                                        ShowProgress(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ShowTitle(
                                title: 'Location :',
                                textStyle: MyConstant().h2Style()),
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
                                        double.parse('${Riskmodels!.lat}'),
                                        double.parse('${Riskmodels!.lng}'),
                                      ),
                                      zoom: 16,
                                    ),
                                    markers: <Marker>{
                                      Marker(
                                          markerId: MarkerId('id'),
                                          onTap: () {
                                            print('#### tap marker');
                                            Appservice().gotodirection(
                                                lat: Riskmodels!.lat!,
                                                lng: Riskmodels!.lng!);
                                          },
                                          position: LatLng(
                                            double.parse('${Riskmodels!.lat}'),
                                            double.parse('${Riskmodels!.lng}'),
                                          ),
                                          infoWindow: InfoWindow(
                                              title: 'เป้าหมายอยู่ที่นี่ ',
                                              snippet:
                                                  'lat = ${Riskmodels!.lat}, lng = ${Riskmodels!.lng}')),
                                    },
                                  ),
                                ),
                              ],
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      if (formKey.currentState!.validate()) {
                                        processdel();
                                      }
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
              )),
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String remark = remarkController.text;

      String id = Riskmodels!.inform_key;
      String cid = Riskmodels!.cid;

      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/edit_informrisk.php?isUpdate=true&id=$id&remark=$remark&status=$selecteValue';
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
        String body = 'กรุณาดูข้อมูลที่เมนูแจ้งจุดเสี่ยงด้วยค่ะ ';

        String sendtoken =
            '${MyConstant.domain}/dopa/api/apinoti.php?isAdd=true&title=$titel&body=$body&token=$tokens';

        sendfcmtomember(sendtoken);
      }
    });
  }

  Future<Null> sendfcmtomember(String sendtoken) async {
    await Dio().get(sendtoken).then((value) => Navigator.pop(context));
  }

  Future<Null> processdel() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String id = Riskmodels!.inform_key;

      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/del_informrisk.php?isDelete=true&id=$id';
      await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
      Navigator.pop(context);
    }
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

  Row Builddetail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            enabled: false,
            maxLines: 3,
            controller: detailController,
            decoration: InputDecoration(
              labelText: 'Detail :',
              border: OutlineInputBorder(),
            ),
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

  Row Buildname(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            enabled: false,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Name in Blank';
              } else {
                return null;
              }
            },
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'ข้อมูลผู้แจ้ง :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
