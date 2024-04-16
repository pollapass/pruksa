import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_titel.dart';

class adminregister extends StatefulWidget {
  const adminregister({Key? key}) : super(key: key);

  @override
  State<adminregister> createState() => _adminregisterState();
}

class _adminregisterState extends State<adminregister> {
  String? selecteValue;
  String? addressValue;
  List poslist = [];
  List addresslist = [];
  String avatar = '';
  File? file;
  double? lat, lng;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mooController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadValueFromAPI();
    loadAddressAPI();
  }

  Future<Null> loadValueFromAPI() async {
    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/dopa/api/getPosition.php?isAdd=true';
    await Dio().get(apiGetProductWhereIdSeller).then((value) {
      // print('value ==> $value');
      var item = json.decode(value.data);
      setState(() {
        poslist = item;
      });
    });
    //print(poslist);
  }

  Future<Null> loadAddressAPI() async {
    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/dopa/api/getaddress.php';
    await Dio().get(apiGetProductWhereIdSeller).then((value) {
      // print('value ==> $value');
      var item = json.decode(value.data);
      setState(() {
        addresslist = item;
      });
    });
    //print(poslist);
  }  
  Widget build(BuildContext context) {
     double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('ลงทะเบียนสำหรับเจ้าหน้า'),

      ),
            body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTitle('ข้อมูลผู้ใช้งาน:'),
                buildUser(size),
                buildPassword(size),
                buildTitle('ข้อมูลทั่วไป :'),
                buildName(size),
                buildLastName(size),
                buildphone(size),
                buildTitle('ข้อมูลที่อยู่:'),
                buildMoo(size),
                BuidAdress(size),
                buildTitle('ข้อมูลตำแหน่ง :'),
                BuidPos(size),
                //print(value);
                SizedBox(
                  height: 10,
                ),
                singupbutton()
              ],
            ),
          ),
        ),
      ),
    );
  }
    Future<Null> checkuser() async {
    String name = nameController.text;

    String phone = phoneController.text;
    String user = userController.text;
    String password = passwordController.text;
    String lastname = lastnameController.text;
    String moo = mooController.text;
    //String  moo = addressValue;

    print(
        '## name = $name, address = $moo, phone = $phone, user = $user, password = $password');
    String path =
        '${MyConstant.domain}/dopa/api/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(path).then((value) async {
      print('## value ==>> $value');
      if (value.toString() == 'null') {
        print('## user OK');

        // No Avatar
        processInsertMySQL(
            name: name,
            phone: phone,
            user: user,
            moo: moo,
            password: password,
            pos: selecteValue,
            lastname: lastname,
            tmbpart: addressValue);
      } else {
        MyDialog().normalDialog(
            context, 'มีผู้ใช้งานนี้อยู่แล้ว ?', 'กรุณาเปลี่บนผู้ใช้งาน User');
      }
    });
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? address,
      String? phone,
      String? user,
      String? pos,
      String? moo,
      String? lastname,
      String? tmbpart,
      String? password}) async {
    // print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/dopa/api/insertUser.php?isAdd=true&name=$name&lastname=$lastname&address=$moo&phone=$phone&user=$user&password=$password&tmbpart=$addressValue&pos=$pos';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'Create New User False !!!', 'Please Try Again');
      }
    });
  }

  Widget singupbutton() => Container(
      width: 250.0,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (selecteValue == null || addressValue == null) {
              print('Non Choose Type User');
              MyDialog().normalDialog(context, 'กรอกข้อมูลไม่่ครบ',
                  'กรุณา กรอกข้อมูลตำแหน่ง และที่อยู่');
            } else {
              print('Process Insert to Database');
              checkuser();
              //processInsertMySQL();
            }
          }
        },
        child: Text('ลงทะเบียน'),
      ));

  Container BuidPos(double size) {
    return Container(
      width: size * 0.7,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุตำแหน่ง'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: poslist.map((pos) {
            return DropdownMenuItem(
                value: pos['pos_id'], child: Text(pos['pos_name']));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selecteValue = value as String;
            });
          }),
    );
  }

  Container BuidAdress(double size) {
    return Container(
      width: size * 0.7,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุตำบล'),
          value: addressValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: addresslist.map((pos) {
            return DropdownMenuItem(
                value: pos['addressid'], child: Text(pos['full_name']));
          }).toList(),
          onChanged: (value) {
            setState(() {
              loadAddressAPI();
              addressValue = value as String;
            });
          }),
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }

  Row buildMoo(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          height: 60,
          child: TextFormField(
            maxLength: 1,
            keyboardType: TextInputType.number,
            controller: mooController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกข้อมูลหมู่ที่ ';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              filled: true,
              fillColor: Colors.white.withOpacity(0.75),
              labelStyle: MyConstant().h3Style(),
              labelText: 'หมู่ที่(ตัวเลข):',
              prefixIcon: Icon(
                Icons.numbers,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          height: 60,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill User in Blank';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              filled: true,
              fillColor: Colors.white.withOpacity(0.75),
              labelStyle: MyConstant().h3Style(),
              labelText: 'ชื่อ :',
              prefixIcon: Icon(
                Icons.fingerprint_outlined,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildLastName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          height: 60,
          child: TextFormField(
            controller: lastnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกนามสกุล';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              filled: true,
              fillColor: Colors.white.withOpacity(0.75),
              labelStyle: MyConstant().h3Style(),
              labelText: 'นามสกุล :',
              prefixIcon: Icon(
                Icons.fingerprint_outlined,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildphone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          height: 60,
          child: TextFormField(
            controller: phoneController,
            maxLength: 10,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกเบอร์โทรศัพท์';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              filled: true,
              fillColor: Colors.white.withOpacity(0.75),
              labelStyle: MyConstant().h3Style(),
              labelText: 'เบอร์โทร :',
              
              prefixIcon: Icon(
                Icons.phone,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก User ด้วย คะ';
              } else {}
              return null;
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'ชื่อผู้ใช้งาน :',
              prefixIcon: Icon(
                Icons.perm_identity,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก รหัสผ่าน ด้วย คะ';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'รหัสผ่าน :',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
