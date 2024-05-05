import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addicarereport extends StatefulWidget {
  final String fullname;
  final String cid;
  const addicarereport({
    Key? key,
    required this.fullname,
    required this.cid,
  }) : super(key: key);

  @override
  State<addicarereport> createState() => _addicarereportState();
}

class _addicarereportState extends State<addicarereport> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  List groupList = [];

  String? selecteValue;
  String avatar = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController priceController = TextEditingController();
 //   TextEditingController priceController = TextEditingController();
  List<String> paths = [];
  late DateTime dateTime;
  final DateFormat formatted = DateFormat('yyyy-MM-dd');
  late Duration duration;
  @override
  void initState() {
    // TODO: implement initState
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);
    loadActivegroupFromAPI();
    priceController.text = '0';
    nameController.text = 'เยี่ยมบ้าน ${widget.fullname}';
    super.initState();

    // initialFile();
  }

  Future<Null> loadActivegroupFromAPI() async {
    String apiGetActiveGroup = '${MyConstant.domain}/dopa/api/getincome.php';
    await dio.Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    //print(poslist);
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลการเยี่ยมบ้าน'),
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              ShowTitle(title: 'เยี่ยมบ้าน ${widget.fullname}'),
              SizedBox(
                height: 10,
              ),
              builddate(),
              const SizedBox(
                height: 20,
              ),
              BuildPlace(),
              const SizedBox(
                height: 20,
              ),
              Builddetail(),
              const SizedBox(
                height: 20,
              ),
              ShowTitle(title: 'กรุณากรอกรูปภาพตอนเยี่ยม'),
              const SizedBox(
                height: 20,
              ),
              buildAvatar(size),
              const SizedBox(
                height: 10,
              ),
              buildGroupList(),
              const SizedBox(
                height: 10,
              ),
              Buildprice(),
              const SizedBox(
                height: 10,
              ),
              buildbutton(),
            ],
          )),
    );
  }

  Future<Null> InsertData() async {
    String name = nameController.text;
    String rdate = dateController.text;
    String detail = detailController.text;
    String price = priceController.text;
    String cid = widget.cid;
    if (file == null || rdate == null || detail == null || name == null || selecteValue == null) {
      // No Avatar
      MyDialog().normalDialog(
          context, 'กรุณากรองข้อมูลให้ครบ', 'ต้องประเมินให้ครบค่ะ');
    } else {
      //      // Have Avatar
      SharedPreferences preference = await SharedPreferences.getInstance();

      String userkey = preference.getString('id')!;

      print('### process Upload Avatar');
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/saveireportpic.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'i$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await dio.MultipartFile.fromFile(file!.path, filename: nameAvatar);
      dio.FormData data = dio.FormData.fromMap(map);
      await dio.Dio().post(apiSaveAvatar, data: data).then((value) {
        avatar = '$nameAvatar';
        print('### avatar = $avatar');
        processInsertMySQL(
          name: name,
          rdate: rdate,
          userkey: userkey,
          detail: detail,
          price: price,
          cid: cid,
        );
      });
    }
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? rdate,
      String? detail,
      String? userkey,
      String? cid,
      String? price}) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/dopa/api/insertireport.php?isAdd=true&titel=$name&rdate=$rdate&detail=$detail&price=$price&userkey=$userkey&image=$avatar&cid=$cid&income=$selecteValue';
    await dio.Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
          Get.back();
        Get.snackbar(
          "Success",
          "เพิ่มข้อมูลการเยี่ยมสำเร็จ",
          colorText: Colors.white,
          backgroundColor: Colors.lightGreen,
          icon: const Icon(Icons.add_alert),
          duration: Duration(seconds: 4),
        );
      
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มข้อมูลได้!!!', 'โปรดลองใหม่อีกครั่ง');
      }
    });
  }

  Widget buildGroupList() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุรายการ'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: groupList.map((code) {
            return DropdownMenuItem(
                value: code['income_id'], child: Text(code['income_name']));
            //print(pos['items_name']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              selecteValue = value as String;

              // print(selectitems);
            });
          }),
    );
  }

  ElevatedButton buildbutton() {
    return ElevatedButton.icon(
      onPressed: () {
        InsertData();
      },
      label: Text(
        "เพิ่มข้อมูล",
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.save,
        size: 24,
        color: Colors.white,
      ),

      //style: MyConstant().mydarkbutton(),
      style: ElevatedButton.styleFrom(
        primary: MyConstant.dark,
        minimumSize: Size(100, 40), //elevated btton background color
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

  Widget builddate() {
    return Container(
      padding: EdgeInsets.all(5),
      //margin: EdgeInsets.only(top: 16),
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

            theme: ThemeData(primarySwatch: Colors.pink),
            locale: Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR,
            //initialDate: DateTime.now(),
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 16,
          );
          print(newDateTime);
          if (newDateTime != null) {
            //setState(() => dateTime = newDateTime);
            setState(() => {
                  //final DateFormat formatted = DateFormat('yyyy-mm-dd');

                  dateTime = newDateTime,
                  // dateController.text = newDateTime.toString()
                  dateController.text = formatted.format(newDateTime),
                  detailController.text =
                      'วันที่ ${dateController.text} ข้าพเจ้า  ได้ออกเยี่ยมและให้กำลังใจ ${widget.fullname} '
                });
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'วันที่เยี่ยม:',
          prefixIcon: Icon(
            Icons.date_range,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Container BuildPlace() {
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
            return 'กรุณากรอกข้อมูลสถานทีเกิดภัย';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกข้อมูลสถานทีเกิดภัย',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container Buildprice() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกข้อมูลสถานทีเกิดภัย',
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
            return 'กรุณากรอกรายละเอียดควารมช่วยเหลือ';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกรายละเอียดควารมช่วยเหลือ เช่น มอบถงยังชีพ',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
