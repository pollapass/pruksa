import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addactive extends StatefulWidget {
  const addactive({Key? key}) : super(key: key);

  @override
  State<addactive> createState() => _addactiveState();
}

class _addactiveState extends State<addactive> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  List groupList = [];
  List itemList = [];
  String? selecteValue;
  String? selectitems;
  String avatar = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  List<String> paths = [];
  late DateTime dateTime;
 final DateFormat formatted = DateFormat('yyyy-MM-dd');
  late Duration duration;
  //List<String> grouplist = [];
  @override
  void initState() {
    // TODO: implement initState
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);
    super.initState();
    loadActivegroupFromAPI();
    // initialFile();
  }

  Future<Null> loadActivegroupFromAPI() async {
    String apiGetActiveGroup = '${MyConstant.domain}/dopa/api/getactgroup.php';
    await Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    //print(poslist);
  }

  Future<Null> _getActiveList() async {
    String? id = selecteValue;
    String apiGetActiveList =
        '${MyConstant.domain}/dopa/api/getactlist.php?isAdd=true&id=$id ';
    await Dio().get(apiGetActiveList).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);
      setState(() {
        itemList = item;
      });
    });
    //print(poslist);
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลการปฎิบัติงาน'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildProductName(constraints),
                    buildProductDetail(constraints),
                    builddate(constraints),
                    buildGroup(constraints),
                    SizedBox(
                      height: 30,
                    ),
                    buildGroupList(constraints),
                    buildAvatar(size),
                    //addactiveButton(constraints)
                    ElevatedButton.icon(
                      onPressed: () {
                        uploadPictureAndInsertData();
                      },
                      icon: Icon(Icons.save), //icon data for elevated button
                      label: Text("เพิ่มข้อมูล"), //label text
                      style:
                          ElevatedButton.styleFrom(primary: MyConstant.primary
                              //elevated btton background color
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGroup(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุประเภท'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: groupList.map((pos) {
            return DropdownMenuItem(
                value: pos['active_id'], child: Text(pos['active_name']));
            // print(pos['active_id']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectitems = null;
              selecteValue = value as String;
              _getActiveList();
              // print(selecteValue);
            });
          }),
    );
  }

  Widget buildGroupList(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุรายการ'),
          value: selectitems,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: itemList.map((code) {
            return DropdownMenuItem(
                value: code['items_code'], child: Text(code['items_name']));
            //print(pos['items_name']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectitems = value as String;

              // print(selectitems);
            });
          }),
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
          width: size * 0.6,
          child: file == null
              ? ShowImage(path: MyConstant.imagig)
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

  Widget buildProductName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'เรื่อง :',
          prefixIcon: Icon(
            Icons.bookmark,
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

  Widget builddateth(BoxConstraints constraints) {
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
          DateTime? picked = await showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime(2020),
              lastDate: new DateTime(2030));
          if (picked != null)
            setState(() => dateController.text = picked.toString());
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

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูลรายละเอียด';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          hintStyle: MyConstant().h3Style(),
          hintText: 'รายละเอียด :',
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
            child: Icon(
              Icons.details_outlined,
              color: MyConstant.dark,
            ),
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

  Future<Null> uploadPictureAndInsertData() async {
    String name = nameController.text;
    String actdate = dateController.text;
    String detail = detailController.text;

    print('## name = $name, date = $actdate, detail = $detail');

    if (file == null || selecteValue == null || selectitems == null) {
      MyDialog().normalDialog(context, 'ข้อมูลไม่ครบ', 'กรอกข้อมูลให้ครบ');
    } else {
      // Have Avatar
      print('### process Upload Avatar');
      SharedPreferences preference = await SharedPreferences.getInstance();

      String userkey = preference.getString('id')!;
      print('### idSeller = $userkey');
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/saveactimages.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'avatar$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameAvatar);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveAvatar, data: data).then((value) {
        avatar = '$nameAvatar';
        processInsertMySQL(
            name: name,
            actdate: actdate,
            detail: detail,
            userkey: userkey,
            act_group: selecteValue,
            act_items: selectitems);
      });
    }
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? actdate,
      String? detail,
      String? userkey,
      String? act_items,
      String? act_group}) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertActReport =
        '${MyConstant.domain}/dopa/api/insertactive.php?isAdd=true&user_key=$userkey&act_date=$actdate &titel=$name&act_detail=$detail&act_items=$act_items&act_group=$act_group&avatar=$avatar';
    await Dio().get(apiInsertActReport).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'Create New User False !!!', 'Please Try Again');
      }
    });

    
  }
}
