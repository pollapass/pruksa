import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';
import '../utility/my_dialog.dart';

class AddDamrong extends StatefulWidget {
  const AddDamrong({Key? key}) : super(key: key);

  @override
  State<AddDamrong> createState() => _AddDamrongState();
}

class _AddDamrongState extends State<AddDamrong> {
  String avatar = '';
  File? file;
  TextEditingController titelController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AppController appController = Get.put(AppController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Appservice().accessdamrong();
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('ร้องเรียน ร้องทุกข์'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        actions: [],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        BuildTitel(),
                        SizedBox(
                          height: 10,
                        ),
                        Builddetail(),
                        SizedBox(
                          height: 20,
                        ),
                        ShowTitle(title: 'เพิ่มรูปถ่ายถ้ามี'),
                        SizedBox(
                          height: 20,
                        ),
                        buildAvatar(size),
                        buildbutton(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.5,
          height: size * 0.5,
          child: file == null
              ? ShowImage(path: MyConstant.imgphoto)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  ElevatedButton buildbutton() {
    return ElevatedButton.icon(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // checkAuthen(user: user, password: password);
          uploadPictureAndInsertData();
        }
      },
      label: Text("เพิ่มข้อมูล"),
      icon: Icon(
        Icons.save,
        size: 24,
      ),

      //style: MyConstant().mydarkbutton(),
      style: ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        minimumSize: Size(100, 40), //elevated btton background color
      ),
    );
  }

  Future<Null> uploadPictureAndInsertData() async {
    String detail = detailController.text;
    String titel = titelController.text;
    SharedPreferences preference = await SharedPreferences.getInstance();

    String cid = preference.getString('cid')!;
    String phone = preference.getString('phone')!;
    String name = preference.getString('name')!;
    String lastname = preference.getString('lastname')!;
    //
    // No Avatar
    if (file == null) {
      processInsertMySQL(
        name: name,
        titel: titel,
        detail: detail,
        phone: phone,
        lastname: lastname,
        cid: cid,
      );
    } else {
      //      // Have Avatar
      print('### process Upload Avatar');
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/savedamrongpic.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'dam$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await dio.MultipartFile.fromFile(file!.path, filename: nameAvatar);
      dio.FormData data = dio.FormData.fromMap(map);
      await dio.Dio().post(apiSaveAvatar, data: data).then((value) {
        avatar = '$nameAvatar';
        print('### avatar = $avatar');
        processInsertMySQL(
          name: name,
          lastname: lastname,
          phone: phone,
          cid: cid,
          titel: titel,
          detail: detail,
        );
      });
    }
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? titel,
      String? phone,
      String? detail,
      String? lastname,
      String? cid}) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertActReport =
        '${MyConstant.domain}/dopa/api/insertinfoappeal.php?isAdd=true&name=$name&lastname=$lastname&cid=$cid&phone=$phone&titel=$titel&image=$avatar&detail=$detail';
    await dio.Dio().get(apiInsertActReport).then((value) {
      if (value.toString() == 'true') {
        for (var i = 0; i < appController.usermodels.length; i++) {
          if ((appController.usermodels[i].token!.isNotEmpty)) {
            Appservice().processnotitouser(
                token: appController.usermodels[i].token!,
                title: 'มีการร้องเรียนร้องทุกข์',
                message: titel!);
          }
        }
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(context, 'เพิ่มข้อมูลไม่ได้', 'กรุณาลองใหม่');
      }
    });
  }

  Container BuildTitel() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: titelController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูลเรื่องร้องเรียน';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกข้อมูลเรื่องร้องเรียน',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container Builddetail() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกรายละเอียด';
          } else {
            return null;
          }
        },
        maxLines: 6,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกรายละเอียดเรื่องร้องเรียน',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
