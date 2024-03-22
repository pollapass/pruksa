// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pruksa/models/news_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class editnews extends StatefulWidget {
  final NewsModel newsModels;
  const editnews({Key? key, required this.newsModels}) : super(key: key);

  @override
  State<editnews> createState() => _editnewsState();
}

class _editnewsState extends State<editnews> {
  NewsModel? newsModels;
  String avatar = '';
  File? file;
  List<String> pathImages = [];
  TextEditingController titleController = TextEditingController();

  TextEditingController detailController = TextEditingController();
  bool statusImage = false;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsModels = widget.newsModels;
    detailController.text = newsModels!.news_description_th;
    titleController.text = newsModels!.news_name_th;
    // print('### image from mySQL ==>> ${productModel!.images}');
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('แก้ไขข่าว'),
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
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShowTitle(
                                title: 'ภาพข่าว :',
                                textStyle: MyConstant().h2Style()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  width: constraints.maxWidth * 0.6,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${MyConstant.domain}/images/news/${newsModels!.news_cover}',
                                    placeholder: (context, url) =>
                                        ShowProgress(),
                                  ),
                                ),
                              ],
                            ),
                            Buildname(constraints),
                            SizedBox(
                              height: 10.0,
                            ),
                            Builddetail(constraints),
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
                        )),
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

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      //MyDialog().showProgressDialog(context);

      String titel = titleController.text;
      String detail = detailController.text;
      String id = newsModels!.news_key;

      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/edit_news.php?isUpdate=true&id=$id&remark=$titel&detail=$detail';
      await Dio().get(apiEditProduct).then((value) {
       Get.back();
        if (value.toString() == 'true') {
          print('value is Success');
          // sendnotitomember(cid);
          MyDialog().normalDialog(context, 'แจ้งเตือน', 'การอับเดทข้อมูลสำเร็จ');
          Get.back();
        } else {
          print('false');
        }
      });
    }
  }

  Future<Null> processdel() async {
    MyDialog().showProgressDialog(context);

    String id = newsModels!.news_key;

    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/del_news.php?isDelete=true&id=$id';
    await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    Navigator.pop(context);
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

  Row Buildname(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            //enabled: false,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Name in Blank';
              } else {
                return null;
              }
            },
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'เรื่อง :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row Builddetail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            // enabled: false,
            maxLines: 6,
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
}
