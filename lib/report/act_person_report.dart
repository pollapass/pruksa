import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class actreportperson extends StatefulWidget {
  const actreportperson({Key? key}) : super(key: key);

  @override
  State<actreportperson> createState() => _actreportpersonState();
}

class _actreportpersonState extends State<actreportperson> {
  final formKey = GlobalKey<FormState>();
  TextEditingController sdateController = TextEditingController();
  TextEditingController edateController = TextEditingController();
  late Duration duration;
  late DateTime dateTime;
  List<SalesData> chartData = [];
  bool? haveData;
  bool load = true;
  final DateFormat formatted = DateFormat('yyyy-MM-dd');
  @override
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
        title: Text('รายงานผู้ลงข้อมูลมากที่สุด'),
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
                    FutureBuilder(
                        future: getJsonFromFirebase(),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            // ignore: prefer_const_constructors
                            return SfCircularChart(
                              legend: Legend(isVisible: true),
                              // Chart title
                              title: const ChartTitle(text: 'ข้อมูลผู้ทำงาน'),
                              series: <CircularSeries>[
                                PieSeries<SalesData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.fullname,
                                  yValueMapper: (SalesData sales, _) =>
                                      int.parse(sales.total),
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                )
                              ],
                            );
                          } else {
                            return Card(
                              elevation: 5.0,
                              child: Container(
                                height: 100,
                                width: 400,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Retriving Firebase data...',
                                          style: TextStyle(fontSize: 20.0)),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator(
                                          semanticsLabel:
                                              'Retriving Firebase data',
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blueAccent),
                                          backgroundColor: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
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
          getJsonFromFirebase();
          loadSalesData();
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

  Future<String> getJsonFromFirebase() async {
    String sdate = sdateController.text;
    String edate = edateController.text;
    String url =
        '${MyConstant.domain}/dopa/api/getactperson.php?isAdd=true&sdate=$sdate&edate=$edate';
    var response = await Dio().get(url);
    print('object is $response ');
    return response.data;
  }

  Future loadSalesData() async {
    final String jsonString = await getJsonFromFirebase();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse)
      chartData.add(SalesData.fromJson(i));
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

class SalesData {
  SalesData(this.fullname, this.total);

  final String fullname;
  final String total;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['fullname'].toString(),
      parsedJson['total'].toString(),
    );
  }
}
