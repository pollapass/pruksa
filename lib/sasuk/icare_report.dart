import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/icare_model.dart';
import 'package:pruksa/models/icare_report_model.dart';
import 'package:pruksa/sasuk/add_ireport.dart';
import 'package:pruksa/sasuk/edit_icare.dart';
import 'package:pruksa/sasuk/icare_edit.dart';

import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class icarereport extends StatefulWidget {
  final String fullname;
  final String cid;
  const icarereport({
    Key? key,
    required this.fullname,
    required this.cid,
  }) : super(key: key);

  @override
  State<icarereport> createState() => _icarereportState();
}

class _icarereportState extends State<icarereport> {
  bool load = true;
  bool? haveData;
  List<icareReport> icarereports = [];
  List<icaremodel> icaremodels = [];
  @override
  void initState() {
    // TODO: implement initState
    loadmemberfromapi();
    findUser();
    super.initState();

    // initialFile();
  }

  Future<Null> findUser() async {
    String user = widget.cid;
    print('cid = $user');
    String apiGetUser =
        '${MyConstant.domain}/dopa/api/geticareWherecid.php?isAdd=true&user=$user';
    await Dio().get(apiGetUser).then((value) {
      print('value from API ==>> $value');
      for (var item in json.decode(value.data)) {
        icaremodel model = icaremodel.fromMap(item);
        print('name of titel =${model.fullname}');

        setState(() {
          icaremodels.add(model);
        });
      }
    });
  }

  Future<Null> loadmemberfromapi() async {
    if (icarereports.length != 0) {
      icarereports.clear();
    } else {}
    String cid = widget.cid;
    print('cid is $cid');
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getreporticare.php?isAdd=true&cid=$cid';
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
          icareReport model = icareReport.fromMap(item);
          print('name of titel =${model.fullname}');

          setState(() {
            load = false;
            haveData = true;
            icarereports.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการให้ความช่วยเหลือของ '),
        actions: [
          IconButton(
            icon: const Icon(Icons.supervised_user_circle),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), //IconButton
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editicare(
                      cid: widget.cid,
                      //     icaremodels: icarereports[index],
                    // Icaremodels: icaremodels.,
                    ),
                  )).then((value) => loadmemberfromapi());
            },
          ),
        ],
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? Container(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: icarereports.length,
                      itemBuilder: (context, index) => Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(242, 244, 247, 0.898)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => icareedit(
                                          icaremodels: icarereports[index],
                                        ),
                                      )).then((value) => loadmemberfromapi());
                                },
                                trailing: Icon(Icons.keyboard_arrow_right,
                                    color: Color.fromARGB(255, 22, 22, 22),
                                    size: 30.0),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          ('${MyConstant.domain}/dopa/resource/icare/images/${icarereports[index].report_images}'))),
                                ),
                                title: Text(
                                  '${icarereports[index].titel}',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 7, 7, 7),
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text(usermodels[index].user_phone),
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(Icons.date_range_rounded,
                                        color: Color.fromARGB(255, 11, 11, 11)),
                                    Text('${icarereports[index].report_date}',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 28, 28, 28))),
                                  ],
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
                      title: 'กรุณาเพิ่มการช่วยเหลือค่ะ',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => addicarereport(
                        cid: widget.cid,
                        fullname: widget.fullname,
                      )))).then((value) => loadmemberfromapi());
        },
        child: Text('เพิ่ม'),
      ),
    );
  }
}
