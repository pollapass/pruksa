import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/models/smiv_revisit_model.dart';
import 'package:pruksa/sasuk/edit_smivrevisit.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class smivHreport extends StatefulWidget {
  const smivHreport({Key? key}) : super(key: key);

  @override
  State<smivHreport> createState() => _smivHreportState();
}

class _smivHreportState extends State<smivHreport> {
  final formKey = GlobalKey<FormState>();
  TextEditingController sdateController = TextEditingController();
  TextEditingController edateController = TextEditingController();
  late Duration duration;
  late DateTime dateTime;
  List<smivrevisitmodel> revisitmodel = [];
  bool? haveData;
  bool load = true;
  final DateFormat formatted = DateFormat('yyyy-MM-dd');
  void initState() {
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);
    super.initState();
    //loadSalesData();
    // initialFile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายงานเยี่ยมผู้ป่วยจิตเวชโรงพยาบาล'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ShowTitle(title: 'กรุณาเลือกวันที่ - ถึงวันที่'),
                    builddate(constraints),
                    buildenddate(constraints),
                    SizedBox(
                      height: 10,
                    ),
                    buildbutton(),
                    SizedBox(
                      height: 10,
                    ),
                    load
                        ? ShowProgress()
                        : haveData!
                            ? Container(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: revisitmodel.length,
                                    itemBuilder: (context, index) => Card(
                                          elevation: 8.0,
                                          margin: new EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    242, 244, 247, 0.898)),
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              editsmivrevisit(
                                                            smivModel:
                                                                revisitmodel[
                                                                    index],
                                                          ),
                                                        ))
                                                    .then((value) =>
                                                        loadmemberfromapi());
                                              },
                                              trailing: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Color.fromARGB(
                                                      255, 22, 22, 22),
                                                  size: 30.0),
                                              leading: Container(
                                                width: 50,
                                                height: 50,
                                                child: CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        ('${MyConstant.domain}/dopa/resource/smivrevisit/images/${revisitmodel[index].images}'))),
                                              ),
                                              subtitle:
                                                  // subtitle: Text(usermodels[index].user_phone),
                                                  Row(
                                                children: <Widget>[
                                                  Icon(Icons.date_range_rounded,
                                                      color: Color.fromARGB(
                                                          255, 11, 11, 11)),
                                                  Text(
                                                      ' วันที่เยี่ยม ${revisitmodel[index].visit_date}}',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              28,
                                                              28,
                                                              28))),
                                                ],
                                              ),
                                              title: Text(
                                                '${revisitmodel[index].sm_name} คะแนน ${revisitmodel[index].total}',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 7, 7, 7),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                    //
                                    ),
                              )
                            : Column(
                                children: [
                                  ShowTitle(
                                    title: 'ไม่มีข้อมูล',
                                    textStyle: MyConstant().h2RedStyle(),
                                  ),
                                  ShowTitle(
                                    title: 'กรุณาเลือกวันที่ใหม่ค่ะ',
                                    textStyle: MyConstant().h2RedStyle(),
                                  ),
                                ],
                              ),
                    // BuildGraph(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton buildbutton() {
    return ElevatedButton.icon(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // checkAuthen(user: user, password: password);
          //uploadPictureAndInsertData();
          // getJsonFromFirebase();
          CheckAccess();
        }
      },
      label: Text(
        "ดูข้อมูล",
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
  Future<Null> CheckAccess() async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    String key = preference.getString('id')!;

    print('### user_key = $key');
    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/checksmiv.php?isAdd=true&key=$key';

    await Dio().get(apigetactivelist).then((value) {
      print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        _dialogBuilder(context);
      } else {
        loadmemberfromapi();
      }
    });
  }
    Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ไม่สามารถดูข้อมูลได้'),
          content: const Text(
            'คุณไม่ได้รับให้อนุญาติให้ดูข้อมูลนี้ หากต้องการดูข้อมูลติดต่อผู้ดูแลระบบ',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ตกลง'),
              onPressed: () {
                // Get.offAllNamed(MyConstant.routeAdmin);
                Navigator.of(context).pop();
              Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<Null> loadmemberfromapi() async {
    if (revisitmodel.length != 0) {
      revisitmodel.clear();
    } else {}
    String sdate = sdateController.text;
    String edate = edateController.text;

    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getrevisitsmiv.php?isAdd=true&sdate=$sdate&edate=$edate';
    await Dio().get(apigetmemberlist).then((value) {
      //print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          smivrevisitmodel model = smivrevisitmodel.fromMap(item);
          print('name of titel =${model.fullname}');

          setState(() {
            load = false;
            haveData = true;
            revisitmodel.add(model);
          });
        }
      }
    });
  }

  Widget builddate(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: sdateController,
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
                  sdateController.text = formatted.format(newDateTime)
                });
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'เริ่มวันที่:',
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

  Widget buildenddate(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: edateController,
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
                  edateController.text = formatted.format(newDateTime)
                });
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'ถึงวันที่:',
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
