import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/models/smiv_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_titel.dart';

class editsmivmoo extends StatefulWidget {
  final smivmodel smivModel;
  const editsmivmoo({Key? key, required this.smivModel}) : super(key: key);

  @override
  State<editsmivmoo> createState() => _editsmivmooState();
}

class _editsmivmooState extends State<editsmivmoo> {
  smivmodel? smivModel;
  String? feel;
  String? sleep;
  String? fear;
  String? walk;
  String? speak;
  TextEditingController nameController = TextEditingController();
  TextEditingController cidController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<File?> files = [];
  bool statusImage = false; // false => Not Change Image
  List<String> pathImages = [];
  File? file;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    smivModel = widget.smivModel;
    //print('### image from mySQL ==>> ${activeModel!.act_key}');
    nameController.text = smivModel!.sm_name;
    cidController.text = smivModel!.cid!;
    addressController.text = smivModel!.address;
    phoneController.text = smivModel!.mobile;
    feel = smivModel!.feel;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล SMIV'),
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
                  Buildname(),
                  SizedBox(
                    height: 10,
                  ),
                  Buildcid(),
                  SizedBox(
                    height: 10,
                  ),
                  Buildaddress(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossFadeState,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //processEdit();
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
                            //_dialogBuilder(context);
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

  Row buildRadiosleep(double size) {
    if (smivModel!.feel == '0') {
    } else {}
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: feel,
            onChanged: (value) {
              setState(() {
                sleep = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่ใ่ช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: sleep,
            onChanged: (value) {
              setState(() {
                sleep = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ใช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Container Buildname() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อเรื่อง';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'ชื่อ-นามสกุล',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container Buildcid() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: cidController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อเรื่อง';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'เลขบัตรประจำตัวประชาชน',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container Buildaddress() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: addressController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อเรื่อง';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'บ้านเลขที่',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
