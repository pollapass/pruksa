import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/models/sm_visit_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_titel.dart';

class editsmvisit extends StatefulWidget {
  final smvisitmodel visitModel;
  const editsmvisit({Key? key, required this.visitModel}) : super(key: key);

  @override
  State<editsmvisit> createState() => _editsmvisitState();
}

class _editsmvisitState extends State<editsmvisit> {
  smvisitmodel? visitModel;
  String? drug;
  String? relative;
  String? addic;
  String? vkey;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late DateTime dateTime;
  final DateFormat formatted = DateFormat('yyyy-MM-dd');
  late Duration duration;

  @override
  void initState() {
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);
    // TODO: implement initState
    super.initState();
    visitModel = widget.visitModel;
    //print('### image from mySQL ==>> ${activeModel!.act_key}');
    nameController.text = visitModel!.note!;
    dateController.text = visitModel!.visit_date;

    drug = visitModel!.drug;
    relative = visitModel!.relative;
    addic = visitModel!.addic;
    vkey = visitModel!.visit_key;
    // สมมุติมีค่า  = 0
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขการเยี่ยม'),
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
              SizedBox(
                height: 10,
              ),
              // buildbutton()
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
    );
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

    String key = visitModel!.visit_key;
    print(' id - $key');

    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/del_smivvisit.php?isDelete=true&id=$key';
    await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    Navigator.pop(context);
  }

  Future<Null> processEdit() async {
    MyDialog().showProgressDialog(context);
    String name = nameController.text;
    String rdate = dateController.text;
    String key = visitModel!.visit_key;

    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/edit_smivvisit.php?isUpdate=true&rdate=$rdate&name=$name&drug=$drug&relative=$relative&addic=$addic&vkey=$key';
    await Dio().get(apiEditProduct).then((value) {
      if (value.toString() == 'true') {
        print('value is Success');
        //  sendnotitomember(cid);\

        Navigator.pop(context);

        Navigator.pop(context);
      } else {
        MyDialog()
            .normalDialog(context, 'ไม่สามารถอับเดทได้!!!', 'กรุณาลองใหม่ค่ะ');
      }
    });
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
