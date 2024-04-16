import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/my_textfield.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addicare extends StatefulWidget {
  const addicare({Key? key}) : super(key: key);

  @override
  State<addicare> createState() => _addicareState();
}

class _addicareState extends State<addicare> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cidController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  List groupList = [];

  String? selecteValue;
  void initState() {
    // TODO: implement initState

    loadActivegroupFromAPI();

    super.initState();

    // initialFile();
  }

  @override
  Future<Null> loadActivegroupFromAPI() async {
    String apiGetActiveGroup = '${MyConstant.domain}/dopa/api/geticaretype.php';
    await dio.Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    //print(poslist);
  }

  Widget buildGroupList() {
    return Container(
      //padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุรายการ'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: groupList.map((code) {
            return DropdownMenuItem(
                value: code['type_id'], child: Text(code['type_name']));
            //print(pos['items_name']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              selecteValue = value as String;

              // print(selectitems);
            });
          }),
    );
  }

  Container Builddetail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกรายละเอียดควารมช่วยเหลือ';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกรายละเอียดควารมช่วยเหลือ เช่น มอบถงยังชีพ',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลกลุ่มเปราะบาง'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    validatefunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณาชื่อนามสกุลด้วยค่ะด้วยค่ะ';
                      } else {
                        return null;
                      }
                    },
                    controller: nameController,
                    hintText: 'ชื่อ-นามสกุล',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    validatefunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณากรอกเบอร์โทรศัพท์ด้วยค่ะ';
                      } else {
                        return null;
                      }
                    },
                    //keyboardType: TextInputType.number,
                    controller: phoneController,
                    hintText: 'เบอร์โทรศัพท์',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    validatefunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณากรอกบ้านเลขที่ด้วยค่ะ';
                      } else {
                        return null;
                      }
                    },
                    //keyboardType: TextInputType.number,
                    controller: addressController,
                    hintText: 'บ้านเลขที่ตามบัตรประชาชน',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    validatefunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณากรอกบ้านเลขที่ด้วยค่ะ';
                      } else {
                        return null;
                      }
                    },
                    controller: cidController,
                    hintText: 'เลขบัตรประจำตัวประชาชน',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Builddetail(),
                  SizedBox(
                    height: 10,
                  ),
                  ShowTitle(title: 'กรุณาเลือกประเภท'),
                  buildGroupList(),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // checkAuthen(user: user, password: password);
                        InsertData();
                      }
                    },
                    icon: Icon(Icons.save), //icon data for elevated button
                    label: Text("เพิ่มข้อมูล"), //label text
                    style: ElevatedButton.styleFrom(primary: MyConstant.primary
                        //elevated btton background color
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

  Future<Null> InsertData() async {
    String name = nameController.text;
    String cid = cidController.text;
    String address = addressController.text;
    String phone = phoneController.text;

    print('## สถานที่ = $name ,cid = $cid');

    if (name == null ||
        cid == null ||
        address == null ||
        phone == null ||
        selecteValue == null) {
      // No Avatar
      MyDialog().normalDialog(
          context, 'กรุณากรองข้อมูลให้ครบ', 'ต้องประเมินให้ครบค่ะ');
    } else {
      //      // Have Avatar
      SharedPreferences preference = await SharedPreferences.getInstance();

      String moopart = preference.getString('moopart')!;
      String addressid = preference.getString('addressid')!;

      String apiInsertActReport =
          '${MyConstant.domain}/dopa/api/inserticare.php?isAdd=true&name=$name&cid=$cid&address=$address&addressid=$addressid&phone=$phone&moopart=$moopart&type=$selecteValue';
      await dio.Dio().get(apiInsertActReport).then((value) {
        if (value.toString() == 'true') {
          Get.back();
          Get.snackbar(
            "Success",
            "เพิ่มข้อมูลคนเปราะบางสำเร็จ",
            colorText: Colors.white,
            backgroundColor: Colors.lightGreen,
            icon: const Icon(Icons.add_alert),
            duration: Duration(seconds: 4),
          );
        } else {
          MyDialog()
              .normalDialog(context, 'ไม่สามารถเพิ่มได้!!!', 'กรุณาลองใหม่ค่ะ');
        }
      });
    }
  }
}
