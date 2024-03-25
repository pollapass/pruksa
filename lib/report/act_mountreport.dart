import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

import 'package:pruksa/models/act_model.dart';
import 'package:pruksa/utility/my_constant.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class actmountreport extends StatefulWidget {
  const actmountreport({Key? key}) : super(key: key);

  @override
  State<actmountreport> createState() => _actmountreportState();
}

class _actmountreportState extends State<actmountreport> {
  bool? haveData;
  bool load = true;
  List<ActModel> actmodels = [];
  List<SalesData> chartData = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    ///loadvaluefromapi();
    loadSalesData();
    // initialFile();
  }



  Future<String> getJsonFromFirebase() async {
    String url = '${MyConstant.domain}/dopa/api/getactivegrap.php?isAdd=true';
    var response = await dio.Dio().get(url);
    print('object is $response ');
    return response.data;
    
  }

  Future loadSalesData() async {
    final String jsonString = await getJsonFromFirebase();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse)
      chartData.add(SalesData.fromJson(i));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ผลงานรอบปีงบประมาณ'),
      ),
      body: Center(
        child: FutureBuilder(
            future: getJsonFromFirebase(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    title: ChartTitle(text: 'ผลงานรอบปีงบประมาณแยกรายเดือน'),
                    series: <LineSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                          dataSource: chartData,
                          xValueMapper: (SalesData sales, _) => sales.month,
                          yValueMapper: (SalesData sales, _) => int.parse(sales.cc),
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ]);
              } else {
                return Card(
                  elevation: 5.0,
                  child: Container(
                    height: 100,
                    width: 400,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('...ประมวลผลจากฐานข้อมูล',
                              style: TextStyle(fontSize: 20.0,color: Colors.lightBlue)),
                          Container(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              semanticsLabel: 'Retriving Mysql data',
                              valueColor: AlwaysStoppedAnimation<Color>(
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
      ),
    );
  }
}

class SalesData {
  SalesData(this.month, this.cc, this.cc1);

  final String month;
  final String cc;
  final String cc1;
  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['month'].toString(),
      parsedJson['cc'].toString(),
      parsedJson['cc1'].toString(),
    );
  }
}
