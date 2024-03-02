import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment({Key? key}) : super(key: key);

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final formKey = GlobalKey<FormState>();

  late DateTime dateTime;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController detailController = TextEditingController();
  late Duration duration;
  List groupList = [];
  // List itemList = [];
  String? selecteValue;
  TimeOfDay selecttime = TimeOfDay(hour: 13, minute: 30);
  final DateFormat formatted = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    // TODO: implement initState
    timeinput.text = "";
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);
    super.initState();
    loadActivegroupFromAPI();
    // initialFile();
  }

  Future<Null> loadActivegroupFromAPI() async {
    String apiGetActiveGroup =
        '${MyConstant.domain}/dopa/api/getsubdepartment.php?isAdd=true';
    await Dio().get(apiGetActiveGroup).then((value) {
      print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    // print(groupList);
  }

  Widget build(BuildContext context) {
    //double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลการจองคิว'),
        backgroundColor: Colors.pinkAccent,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildGroupList(constraints),
                    builddate(constraints),
                    buildTime(constraints),
                    SizedBox(
                      height: 10,
                    ),
                    BuildDetail(constraints),
                    SizedBox(
                      height: 20,
                    ),
                    addactiveButton(constraints),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container BuildDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
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
          hintText: 'กรุณากรอกรายละเอียด',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container addactiveButton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            processInsertMySQL();
          }
        },
        child: Text(
          'เพิ่มข้อมูลการจองคิว',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> processInsertMySQL() async {
    String date = dateController.text;
    String detail = detailController.text;
    String timer = timeinput.text;

    SharedPreferences preference = await SharedPreferences.getInstance();

    String cid = preference.getString('cid')!;
    String phone = preference.getString('phone')!;
    String name = preference.getString('name')!;
    String lastname = preference.getString('lastname')!;
    String apiInsertUser =
        '${MyConstant.domain}/dopa/api/insertappointment.php?isAdd=true&name=$name&lastname=$lastname&cid=$cid&phone=$phone&date=$date&time=$timer&detail=$detail&sub=$selecteValue';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มข้อมูลได้!!!', 'โปรดลองใหม่อีกครั่ง');
      }
    });
  }

  Widget buildGroupList(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุฝ่ายที่นัดหมาย'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: groupList.map((code) {
            return DropdownMenuItem(
                value: code['sub_id'], child: Text(code['sub_name']));
            //print(pos['items_name']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              selecteValue = value as String;

              print(selecteValue);
            });
          }),
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
                  dateController.text = formatted.format(newDateTime)
                });
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'วันที่นัด:',
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

  Widget buildTime(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: timeinput,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูลเวลา';
          } else {
            return null;
          }
        },
        // keyboardType: TextInputType.datetime,
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            initialTime: TimeOfDay.now(),
            context: context,
          );

          if (pickedTime != null) {
            print(pickedTime.format(context)); //output 10:51 PM
            DateTime parsedTime =
                DateFormat.jm().parse(pickedTime.format(context).toString());
            //converting to DateTime so that we can further format on different pattern.
            print(parsedTime); //output 1970-01-01 22:53:00.000
            String formattedTime = DateFormat('HH:mm').format(parsedTime);
            print(formattedTime); //output 14:59:00
            //DateFormat() is from intl package, you can format the time on any pattern you need.

            setState(() {
              timeinput.text = formattedTime; //set the value of text field.
            });
          } else {
            print("Time is not selected");
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'เวลา :',
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
