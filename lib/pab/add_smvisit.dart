import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

class addsmvisit extends StatefulWidget {
  final String cid;
  final String name;
  const addsmvisit({Key? key, required this.cid, required this.name})
      : super(key: key);

  @override
  State<addsmvisit> createState() => _addsmvisitState();
}

class _addsmvisitState extends State<addsmvisit> {
  String? drug;
  String? relative;
  String? addic;
  String? confirm;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late DateTime dateTime;
  final DateFormat formatted = DateFormat('yyyy-MM-dd');
  late Duration duration;
  AppController appController = Get.put(AppController());
  @override
  void initState() {
    // TODO: implement initState
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);

    super.initState();
    Appservice().accesssmiv();
    // initialFile();
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลการเยี่ยม'),
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 10,
              ),
              builddate(),
              const SizedBox(
                height: 10,
              ),
              ShowTitle(title: 'การกินยา'),
              builddrug(size),
              ShowTitle(title: 'ญาติ/ผุ้ดูแล'),
              builrelative(size),
              ShowTitle(title: 'การใช้สารเสพติด บุหรี่ สุรา สารเสพติดอื่นๆ'),
              buildaddic(size),
              ShowTitle(title: 'หมายเหตุ'),
              Builddetail(),
              ShowTitle(title: 'แจ้งเตือนโรงพยาบาล'),
              buildconfirm(size),
              SizedBox(
                height: 10,
              ),
              buildbutton()
            ],
          )),
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

  Future<Null> InsertData() async {
    String name = nameController.text;
    String rdate = dateController.text;

    String cid = widget.cid;

    if (rdate == null || drug == null || relative == null || addic == null) {
      // No Avatar
      MyDialog().normalDialog(
          context, 'กรุณากรองข้อมูลให้ครบ', 'ต้องประเมินให้ครบค่ะ');
    } else {
      print('confrim = $confirm');
      if (confirm == 'Y') {
        for (var i = 0; i < appController.usermodels.length; i++) {
          if ((appController.usermodels[i].token!.isNotEmpty)) {
            Appservice().processnotitouser(
                token: appController.usermodels[i].token!,
                title: 'แจ้งเตือนผู้ป่วย SMIV',
                message: 'กรุณาดูข้อมูลที่เมนู รายงาน SMIV!!');
          }
        }
      }
      //      // Have Avatar
      SharedPreferences preference = await SharedPreferences.getInstance();

      String userkey = preference.getString('id')!;
      String apiInsertUser =
          '${MyConstant.domain}/dopa/api/insertsmvisit.php?isAdd=true&note=$name&rdate=$rdate&drug=$drug&relative=$relative&addic=$addic&cid=$cid&userkey=$userkey';
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
  }

  Column builrelative(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: relative,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                relative = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ขาดผู้ดูแล',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: '1',
            groupValue: relative,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                relative = value as String?;
              });
            },
            title: ShowTitle(
              title: 'มีปัญหาในการดูแล',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: '2',
            groupValue: relative,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                relative = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่มีปัญหาในการดูแล',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildconfirm(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: 'N',
            groupValue: confirm,
            onChanged: (value) {
              setState(() {
                confirm = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่ใ่ช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: 'Y',
            groupValue: confirm,
            onChanged: (value) {
              setState(() {
                confirm = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ใช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
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
        controller: nameController,
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกหมายเหตุ(ถ้ามี)',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Column buildaddic(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size * 0.5,
          child: RadioListTile(
            value: '0',
            groupValue: addic,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                addic = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ใช้ประจำ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.5,
          child: RadioListTile(
            value: '1',
            groupValue: addic,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                addic = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ใช้บ้าง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.5,
          child: RadioListTile(
            value: '2',
            groupValue: addic,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                addic = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่ใช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column builddrug(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size * 0.5,
          child: RadioListTile(
            value: '0',
            groupValue: drug,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                drug = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่กินยา',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.5,
          child: RadioListTile(
            value: '1',
            groupValue: drug,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                drug = value as String?;
              });
            },
            title: ShowTitle(
              title: 'กินยาไม่สมำ่เสมอ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.5,
          child: RadioListTile(
            value: '2',
            groupValue: drug,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                drug = value as String?;
              });
            },
            title: ShowTitle(
              title: 'กินยา',
              textStyle: MyConstant().h3Style(),
            ),
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
}
