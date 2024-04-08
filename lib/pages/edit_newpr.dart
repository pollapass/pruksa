import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruksa/models/newspr_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';

class EditNewpr extends StatefulWidget {
  final NewsprModel newprModels;
  const EditNewpr({Key? key, required this.newprModels}) : super(key: key);

  @override
  State<EditNewpr> createState() => _EditNewprState();
}

class _EditNewprState extends State<EditNewpr> {
  NewsprModel? newprModels;
  TextEditingController titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newprModels = widget.newprModels;

    titleController.text = newprModels!.book_name;
    // print('### image from mySQL ==>> ${productModel!.images}');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขประกาศ คำสั่ง'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Buildname(constraints),
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
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      //MyDialog().showProgressDialog(context);

      String titel = titleController.text;

      String id = newprModels!.book_key;

      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/edit_newspr.php?isUpdate=true&id=$id&remark=$titel';
      await Dio().get(apiEditProduct).then((value) {
        Get.back();
        if (value.toString() == 'true') {
          print('value is Success');
          // sendnotitomember(cid);
          MyDialog()
              .normalDialog(context, 'แจ้งเตือน', 'การอับเดทข้อมูลสำเร็จ');
          // Get.back();
        } else {
          print('false');
        }
      });
    }
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

  Future<Null> processdel() async {
    MyDialog().showProgressDialog(context);

    String id = newprModels!.book_key;

    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/del_newspr.php?isDelete=true&id=$id';
    await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    Navigator.pop(context);
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
}
