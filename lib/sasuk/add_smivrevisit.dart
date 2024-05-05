import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class addsmivrevisit extends StatefulWidget {
  final String fullname;
  final String cid;
  const addsmivrevisit({
    Key? key,
    required this.fullname,
    required this.cid,
  }) : super(key: key);

  @override
  State<addsmivrevisit> createState() => _addsmivrevisitState();
}

class _addsmivrevisitState extends State<addsmivrevisit> {
  final formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  late DateTime dateTime;
  final DateFormat formatted = DateFormat('yyyy-MM-dd');
  late Duration duration;
  String? mental;
  String? med;
  String? relat;
  String? prac;
  String? occu;
  String? rela;
  String? en;
  String? com;
  String? edu;
  String? drug;
  String avatar = '';
  File? file;
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);

    nameController.text = 'เยี่ยมบ้าน ${widget.fullname}';
    super.initState();

    // initialFile();
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มประวัติการเยี่ยม  ${widget.fullname}'),
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              builddate(),
              buildTitle1('ต้องกรอกให้ครบทั้ง 10 ข้อ'),
              buildTitle1('1.ด้านอาการทางจิต'),
              buildRadiomental(size),
              buildTitle1('2.ด้านการกินยา'),
              buildmed(size),
              buildTitle1('3.ด้านผุ้ดูแล/ญาติ'),
              buildrelative(size),
              buildTitle1('4.ด้านการทำกิจวัตรประจำวัน'),
              buildprac(size),
              buildTitle1('5.ด้านการประกอบอาชีพ'),
              buildoccu(size),
              buildTitle1('6.ด้านความสัมพันธ์ในครอบครัว'),
              buildrela(size),
              buildTitle1('7.ด้านสิ่งแวดล้อม'),
              builden(size),
              buildTitle1('8.ด้านการสื่อสาร'),
              buildcom(size),
              buildTitle1('9.ด้านความสามารถในการเรียนรู้เบื้องต้น'),
              buildedu(size),
              buildTitle1('10.ด้านการใช้สารเสพติด (บุหร่ี่/เหล้า/ยาเสพติด)'),
              builddrug(size),
              Builddetail(),
              buildTitle1('รูปเยี่ยมบ้าน (ถ้ามี)'),
              buildAvatar(size),
              buildbutton(),
            ],
          )),
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

  Future<Null> uploadPictureAndInsertData() async {
    String note = nameController.text;
    String rdate = dateController.text;
    SharedPreferences preference = await SharedPreferences.getInstance();

    String cid = widget.cid;
    String userkey = preference.getString('id')!;

    //
    // No Avatar
    if (rdate == null ||
        mental == null ||
        med == null ||
        relat == null ||
        prac == null ||
        occu == null ||
        edu == null ||
        en == null ||
        drug == null ||
        rela == null ||
          file == null ||
        com == null) {
      MyDialog().normalDialog(
          context, 'กรุณากรองข้อมูลให้ครบ', 'ต้องประเมินให้ครบค่ะ');
    } else
     {
      //      // Have Avatar
      print('### process Upload Avatar');
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/saverevisitpic.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'rvisit$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await dio.MultipartFile.fromFile(file!.path, filename: nameAvatar);
      dio.FormData data = dio.FormData.fromMap(map);
      await dio.Dio().post(apiSaveAvatar, data: data).then((value) {
        avatar = '$nameAvatar';
        print('### avatar = $avatar');
        processInsertMySQL(
          rdate: rdate,
          mental: mental,
          med: med,
          relat: relat,
          prac: prac,
          occu: occu,
          edu: edu,
          en: en,
          drug: drug,
          rela: rela,
          com: com,
          cid: cid,
          note: note,
          userkey: userkey,
        );
      });
    }
  }

  Future<Null> processInsertMySQL(
      {String? rdate,
      String? mental,
      String? med,
      String? relat,
      String? prac,
      String? occu,
      String? edu,
      String? en,
      String? drug,
      String? rela,
      String? com,
      String? note,
      String? userkey,
      String? cid}) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertActReport =
        '${MyConstant.domain}/dopa/api/insertrevisit.php?isAdd=true&rdate=$rdate&mental=$mental&cid=$cid&med=$med&relat=$relat&image=$avatar&prac=$prac&occu=$occu&edu=$edu&en=$en&drug=$drug&rela=$rela&com=$com&note=$note&userkey=$userkey';
    await dio.Dio().get(apiInsertActReport).then((value) {
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
        MyDialog().normalDialog(context, 'เพิ่มข้อมูลไม่ได้', 'กรุณาลองใหม่');
      }
    });
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
          hintText: 'หมายเหตุ(ถ้ามี)',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container buildTitle1(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }

  Column buildRadiomental(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: mental,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                mental = value as String?;
              });
            },
            title: ShowTitle(
              title:
                  'ไม่มีอาการ ผู้ป่วยรู้เรื่อง ช่วยตนเองกได้ ดำรงชีวิตชุมชนได้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: mental,
            onChanged: (value) {
              setState(() {
                mental = value as String?;
              });
            },
            title: ShowTitle(
              title:
                  'ม่ีบ้าง ผู้ป่วยมีพฤติกรรมที่ผิดปกติอย่างน้อย 10 ครั้งใน 1 เดือน',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: mental,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                mental = value as String?;
              });
            },
            title: ShowTitle(
              title:
                  'มีบ่อย ผู้ป่วยมีพฤติกรรมที่ผิดปกติมากกว่า10 ครั้งใน 1 เดือน',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column buildmed(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: med,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                med = value as String?;
              });
            },
            title: ShowTitle(
              title: 'สม่ำเสมอ รับประทานยาครบทุกวัน ตามแพทย์สั่ง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: med,
            onChanged: (value) {
              setState(() {
                med = value as String?;
              });
            },
            title: ShowTitle(
              title:
                  'ไม่สม่ำเสมอ รับประทานยาไม่ครบ ตามแพทย์สั่ง แต่ยังรับประทานยาเป็นบางเวลา',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: med,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                med = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่กินยา ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column buildrelative(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: relat,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                relat = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ดี มีผู้ดูแลหลัก เป็นคนในครอบครัว',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: relat,
            onChanged: (value) {
              setState(() {
                relat = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ปานกลาง มึผู้ดูแล เป็นคนนอกครอบครับ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: relat,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                relat = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ปรับปรุง ไม่มีคนดูแล หรือไม่มีศักยภาพเพียงพอ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column buildoccu(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: occu,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                occu = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ทำได้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: occu,
            onChanged: (value) {
              setState(() {
                occu = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ทำได้บ้าง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: occu,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                occu = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ทำไม่ได้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column buildprac(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: prac,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                prac = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ทำได้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: prac,
            onChanged: (value) {
              setState(() {
                prac = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ทำได้บ้าง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: prac,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                prac = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ทำไม่ได้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column buildrela(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: rela,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                rela = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ครอบครัวมีการชมเชย มองผู้ป่วยบวกเป็นส่วนใหญ่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: rela,
            onChanged: (value) {
              setState(() {
                rela = value as String?;
              });
            },
            title: ShowTitle(
              title:
                  'ทำได้บ้าง ครอบครัวชมเชยบ้าง แต่ยังมีการตัดเตือน ต่อว่า บางครัั้ง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: rela,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                rela = value as String?;
              });
            },
            title: ShowTitle(
              title:
                  'ทำไม่ได้ ครอบครัวมีปฎิสัมพันธ์ด้านลบ เช่น ดูถูก ด่าว่า หลายครั้ง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column builden(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: en,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                en = value as String?;
              });
            },
            title: ShowTitle(
              title: 'มีที่อยู่อาศัยเป็นหลักแหล่ง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: en,
            onChanged: (value) {
              setState(() {
                en = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ปานกลาง มีที่อยู่อาศัย แต่แยกจากครอบครัวอยู่คนเด่ียว',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: en,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                en = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ปรับปรุง ไม่ม่ีที่อยู่อาศัย เร่ร่อน',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column buildedu(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: edu,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                edu = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ดี บอกครั้ืงเดียวสองครั้งสามารถทำได้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: edu,
            onChanged: (value) {
              setState(() {
                edu = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ปานกลาง สอนซ้ำๆจึงสามารถทำได้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: edu,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                edu = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ปรับปรุง สอนเท่าไหร่ก็จำไม่ได้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Column buildcom(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: com,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                com = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ดี',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: com,
            onChanged: (value) {
              setState(() {
                com = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ปานกลาง ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: com,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                com = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ปรับปรุง ไม่พูดกับใครเลย',
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
      children: [
        Container(
          // width: size * 0.4,
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
              title: 'ไม่ใช้',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //  width: size * 0.3,
          child: RadioListTile(
            value: '2',
            activeColor: Colors.blue,
            groupValue: drug,
            onChanged: (value) {
              setState(() {
                drug = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ใช้บ้าง ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          //width: size * 0.3,
          child: RadioListTile(
            value: '3',
            groupValue: drug,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                drug = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ใช้ประจำ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
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
}
