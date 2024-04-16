import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class addpaynews extends StatefulWidget {
  const addpaynews({Key? key}) : super(key: key);

  @override
  State<addpaynews> createState() => _addpaynewsState();
}

class _addpaynewsState extends State<addpaynews> {
  String avatar = '';
  String filetext = '';
  File? file;
  final formKey = GlobalKey<FormState>();
  TextEditingController titelController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  AppController appController = Get.put(AppController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Appservice().processalladmin();
    Appservice().processallmember();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่่มประกาศจัดซิ้อจัดจ้าง'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Buildtitel(),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('อับโหลดเอกสาร PDF'),
                IconButton(
                  onPressed: () {
                    //uploadpdf();
                    _pickfile();
                    // FilePickerResult? result = await FilePicker.platform.pickFiles();
                  },
                  icon: Icon(
                    Icons.add_to_drive,
                    size: 40,
                    color: MyConstant.dark,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(filetext),
            SizedBox(
              height: 20,
            ),
            buildbutton()
          ],
        ),
      ),
    );
  }

  Future<Null> uploadPictureAndInsertData() async {
    String titel = titelController.text;

    if (file == null) {
      print('กรุณาแนนเอกสารด้วยค่ะ');
    } else {
      //      // Have Avatar
      SharedPreferences preference = await SharedPreferences.getInstance();
      String userkey = preference.getString('id')!;

      print('### key = $userkey');

      print('### process Upload Avatar');
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/savedocpay.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'py$i.pdf';
      Map<String, dynamic> map = Map();
      map['file'] =
          await dio.MultipartFile.fromFile(file!.path, filename: nameAvatar);
      dio.FormData data = dio.FormData.fromMap(map);
      await dio.Dio().post(apiSaveAvatar, data: data).then((value) {
        avatar = '$nameAvatar';
        print('### avatar = $avatar');
        processInsertMySQL(
          titel: titel,
          userkey: userkey,
        );
      });
    }
  }

  Future<Null> processInsertMySQL({
    String? titel,
    String? userkey,
  }) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/dopa/api/insertpaynews.php?isAdd=true&titel=$titel&doc=$avatar&userkey=$userkey';
    await dio.Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Get.back();
        Get.snackbar(
          "Success",
          "เพิ่มประกาศจัดซื้อจัดจ้างสำเร็จ",
          colorText: Colors.white,
          backgroundColor: Colors.lightGreen,
          icon: const Icon(Icons.add_alert),
          duration: Duration(seconds: 4),
        );
        for (var i = 0; i < appController.usermodels.length; i++) {
          if ((appController.usermodels[i].token!.isNotEmpty)) {
            Appservice().processnotitouser(
                token: appController.usermodels[i].token!,
                title: 'มีประกาศจัดซื้อจัดจ้างจากอำเภอบ้านหลวง',
                message: titel!);
          }
        }

        for (var i = 0; i < appController.memberModels.length; i++) {
          if ((appController.memberModels[i].token!.isNotEmpty)) {
            Appservice().processnotitomember(
                token: appController.memberModels[i].token!,
                title: 'มีประกาศจัดซื้อจัดจ้างจากอำเภอบ้านหลวง',
                message: titel!);
          }
        }

        // Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มข้อมูลได้!!!', 'โปรดลองใหม่อีกครั่ง');
      }
    });
  }



  void _pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File _file = File(result.files.single.path!);
      setState(() {
        filetext = _file.path;
        file = File(result.files.single.path!);
      });
    }
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
        primary: MyConstant.dark,
        minimumSize: Size(100, 40), //elevated btton background color
      ),
    );
  }

  Container Buildtitel() {
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
            return 'กรุณากรอกข้อมูลด้วยครับ';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกชื่อเรื่อง',
          hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
        ),
      ),
    );
  }
}
