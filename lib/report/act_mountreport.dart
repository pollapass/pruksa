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

  Future<Null> loadvaluefromapi() async {
    if (actmodels.length != 0) {
      actmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getactivegrap.php?isAdd=true';

    await dio.Dio().get(apigetactivelist).then((value) {
      print('value ==> $value');

      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          ActModel model = ActModel.fromMap(item);
          print('name of titel =${model.cc}');

          setState(() {
            load = false;
            haveData = true;
            actmodels.add(model);
          });
        }
      }
    });
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
        title: Text('Bar Chart'),
      ),
      body: Center(
        child: FutureBuilder(
            future: getJsonFromFirebase(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    title: ChartTitle(text: 'Half yearly sales analysis'),
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
                          Text('Retriving Firebase data...',
                              style: TextStyle(fontSize: 20.0)),
                          Container(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              semanticsLabel: 'Retriving Firebase data',
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
