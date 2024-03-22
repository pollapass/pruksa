import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/appointment_model.dart';
import 'package:pruksa/pages/edit_appoint.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class AppointList extends StatefulWidget {
  const AppointList({Key? key}) : super(key: key);

  @override
  State<AppointList> createState() => _AppointListState();
}

class _AppointListState extends State<AppointList> {
  bool? haveData;
  bool load = true;
  List<AppointModel> appointmodels = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (appointmodels.length != 0) {
      appointmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getappointmento.php?isAdd=true';

    await Dio().get(apigetactivelist).then((value) {
      print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          AppointModel model = AppointModel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            appointmodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลบัตรคิว'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: appointmodels.length,
                  itemBuilder: (context, index) => Card(
                        elevation: 10.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 242, 247, 0.894)),
                          child: ListTile(
                            onTap: () {
                                     Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => editAppoint(
                                      appointModels: appointmodels[index],
                                    ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            title:
                                Text('แผนก:${appointmodels[index].sub_name}'),
                            subtitle: Text(
                              'วันที่:${appointmodels[index].app_date}เวลา ${appointmodels[index].app_time}',
                              style: MyConstant().h3RedStyle(),
                            ),
                            trailing: Icon(Icons.date_range,
                                color: Color.fromARGB(255, 22, 22, 22),
                                size: 30.0),
                          ),
                        ),
                      )
                  //
                  )
              : Column(
                  children: [
                    ShowTitle(
                      title: 'ไม่มีประวัติการจองคิว',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),
    );
  }
}
