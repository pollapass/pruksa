import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewsPr extends StatefulWidget {
  const AddNewsPr({Key? key}) : super(key: key);

  @override
  State<AddNewsPr> createState() => _AddNewsPrState();
}

class _AddNewsPrState extends State<AddNewsPr> {
  String avatar = '';
  String filetext = '';
  File? file;
  final formKey = GlobalKey<FormState>();
  TextEditingController titelController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มประกาศ'),
        backgroundColor: MyConstant.primary,
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
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/savedocpr.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'pr$i.pdf';
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameAvatar);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveAvatar, data: data).then((value) {
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
        '${MyConstant.domain}/dopa/api/insertnewspr.php?isAdd=true&titel=$titel&doc=$avatar&userkey=$userkey';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มข้อมูลได้!!!', 'โปรดลองใหม่อีกครั่ง');
      }
    });
  }

  Future uploadpdf() async {
    var dio = Dio();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? " ");
      String fileName = file.path.split('/').last;
      String path = file.path;

      FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(file!.path, filename: fileName)
      });

      final response = dio.post(
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
      allowedExtensions: ['jpg', 'pdf', 'doc'],
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
