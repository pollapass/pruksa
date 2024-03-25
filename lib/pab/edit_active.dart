import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/models/active_list_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';

class EditActive extends StatefulWidget {
  final ActiveListModel activeModel;
  const EditActive({Key? key, required this.activeModel}) : super(key: key);

  @override
  State<EditActive> createState() => _EditActiveState();
}

class _EditActiveState extends State<EditActive> {
  ActiveListModel? activeModel;
  TextEditingController titelController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  List<File?> files = [];
  bool statusImage = false; // false => Not Change Image
  List<String> pathImages = [];
  File? file;
    late Duration duration;
  late DateTime dateTime;

  final DateFormat formatted = DateFormat('yyyy-MM-dd');
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeModel = widget.activeModel;
    //print('### image from mySQL ==>> ${activeModel!.act_key}');
    titelController.text = activeModel!.titel;
    dateController.text = activeModel!.act_date;
    detailController.text = activeModel!.act_detail;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลการปฎิบัติงาน'),
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
                  BuildTitel(),
                  SizedBox(
                    height: 10,
                  ),
                  BuildDetail(),
                  builddate(constraints),
                  Text(
                    'รูปภาพ',
                    style: MyConstant().gh2Style(),
                  ),
                  buildAvatar(constraints),
                  SizedBox(height: 20,),
                             Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossFadeState,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                      processEdit();
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
    );
  }
  Future<Null> processEdit() async {
    print('processEditProfileSeller Work');

    MyDialog().showProgressDialog(context);

    if (formKey.currentState!.validate()) {
      if (file == null) {
        print('## User Current Avatar');
        editValueToMySQL(activeModel!.act_images);
      } else {
         String apiSaveAvatar = '${MyConstant.domain}/dopa/api/saveactimages.php';

        List<String> nameAvatars = activeModel!.act_images.split('/');
        String nameFile = nameAvatars[nameAvatars.length - 1];
        nameFile = 'edit${Random().nextInt(1000)}$nameFile';

        print('## User New Avatar nameFile ==>>> $nameFile');

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameFile);
        FormData formData = FormData.fromMap(map);
        await Dio().post(apiSaveAvatar, data: formData).then((value) {
          print('Upload Succes');
          String pathAvatar = '$nameFile';
          editValueToMySQL(pathAvatar);
        });
      }
    }
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
  Future<void> processdel() async {
    MyDialog().showProgressDialog(context);

    String id = activeModel!.act_key;
    print(' id - $id');

    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/del_active.php?isDelete=true&id=$id';
    await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    Navigator.pop(context);
  }
  Future<Null> editValueToMySQL(String pathAvatar) async {
    print('## pathAvatar ==> $pathAvatar');
    String apiEditProfile =
        '${MyConstant.domain}/dopa/api/edit_active.php?isAdd=true&id=${activeModel!.act_key}&titel=${titelController.text}&detail=${detailController.text}&act_date=${dateController.text}&avatar=$pathAvatar';
    await Dio().get(apiEditProfile).then((value) {
      Navigator.pop(context);
    Navigator.pop(context);
    });
  }
  Container BuildDetail() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
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
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'รายละเอียด',
          hintStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
        ),
      ),
    );
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
            return 'กรุณากรอกชื่อเรื่อง';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'ชื่อเรื่อง',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Future<Null> createAvatar({ImageSource? source}) async {
    try {
      var result = await ImagePicker().getImage(
        source: source!,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              IconButton(
                onPressed: () => createAvatar(source: ImageSource.camera),
                icon: Icon(
                  Icons.add_a_photo,
                  color: MyConstant.dark,
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.6,
                height: constraints.maxWidth * 0.6,
                child: activeModel == null
                    ? ShowProgress()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: activeModel!.act_images == null
                            ? ShowImage(path: MyConstant.avatar)
                            : file == null
                                ? buildShowImageNetwork()
                                : Image.file(file!),
                      ),
              ),
              IconButton(
                onPressed: () => createAvatar(source: ImageSource.gallery),
                icon: Icon(
                  Icons.add_photo_alternate,
                  color: MyConstant.dark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  CachedNetworkImage buildShowImageNetwork() {
    return CachedNetworkImage(
      imageUrl:
          '${MyConstant.domain}/dopa/resource/active/images/${activeModel!.act_images}',
      placeholder: (context, url) => ShowProgress(),
    );
  }

    Widget builddate(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: dateController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูลวันที่';
          } else {
            return null;
          }
        },
        // keyboardType: TextInputType.datetime,
        onTap: () async {
          DateTime? newDateTime = await showRoundedDatePicker(
            context: context,
            locale: Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 16,
          );
          print(newDateTime);
          if (newDateTime != null) {
            //setState(() => dateTime = newDateTime);
            setState(() => {
                  dateTime = newDateTime,
                  dateController.text = formatted.format(newDateTime)
                   //sdateController.text = formatted.format(newDateTime)
                });
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'วันที่ปฎิบัติงาน :',
          prefixIcon: Icon(
            Icons.date_range,
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
