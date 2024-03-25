import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addbooksend extends StatefulWidget {
  const addbooksend({Key? key}) : super(key: key);

  @override
  State<addbooksend> createState() => _addbooksendState();
}

class _addbooksendState extends State<addbooksend> {
  String avatar = '';
  String filetext = '';
  File? file;
  final formKey = GlobalKey<FormState>();
  TextEditingController titelController = TextEditingController();

  AppController appController = Get.put(AppController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Appservice().processalladmin();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มหนังสือเวียน'),
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
                Text('อับโหลดเอกสาร PDF เท่านั้นค่ะ'),
                IconButton(
                  onPressed: () {
                    //uploadpdf();
                    _pickfile();
                    // FilePickerResult? result = await FilePicker.platform.pickFiles();
                  },
                  icon: Icon(
                    Icons.picture_as_pdf,
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
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/savebooksend.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'send$i.pdf';
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
        '${MyConstant.domain}/dopa/api/insertbooksend.php?isAdd=true&titel=$titel&doc=$avatar&userkey=$userkey';
    await dio.Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        for (var i = 0; i < appController.usermodels.length; i++) {
          if ((appController.usermodels[i].token!.isNotEmpty)) {
            Appservice().processnotitouser(
                token: appController.usermodels[i].token!,
                title: 'มีหนังสือเวียนถึงท่านค่ะ',
                message: titel!);
          }
        }

        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มข้อมูลได้!!!', 'โปรดลองใหม่อีกครั่งค่ะ');
      }
    });
  }

  Future uploadpdf() async {
    var Dios = dio.Dio();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? " ");
      String fileName = file.path.split('/').last;
      String path = file.path;

      dio.FormData data = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(file!.path, filename: fileName)
      });

      final response = Dios.post(
          '${MyConstant.domain}/dopa/api/insertfaq1.php?isAdd=true',
          data: data, onSendProgress: (int sent, int total) {
        print('$sent,$total');
      });
    } else {
      print("Result is null ");
    }
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
            return 'กรุณากรอกข้อมูลด้วยค่ะ';
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
