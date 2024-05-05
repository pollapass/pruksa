import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/sm_visit_model.dart';
import 'package:pruksa/models/smiv_model.dart';
import 'package:pruksa/pab/add_smvisit.dart';
import 'package:pruksa/pab/edit_smvisit.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class smvist extends StatefulWidget {
  final String cid;
  final String name;
 

  const smvist({Key? key, required this.cid,required this.name}) : super(key: key);

  @override
  State<smvist> createState() => _smvistState();
}

class _smvistState extends State<smvist> {
  bool load = true;
  bool? haveData;
  List<smvisitmodel> icarereports = [];
  @override
  void initState() {
    // TODO: implement initState
    loadmemberfromapi();

    super.initState();

    // initialFile();
  }

  Future<Null> loadmemberfromapi() async {
    if (icarereports.length != 0) {
      icarereports.clear();
    } else {}
    String cid = widget.cid;
    print('cid is $cid');
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getsmvisit.php?isAdd=true&cid=$cid';
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
          smvisitmodel model = smvisitmodel.fromMap(item);
          print('name of titel =${model.visit_key}');

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
        title: Text('ประวัติการเยี่ยม  ${widget.name}'),
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
                                          builder: (context) => editsmvisit(
                                            visitModel: icarereports[index],
                                              ),
                                        )).then((value) => loadmemberfromapi());
                                  },
                                  trailing: Icon(Icons.keyboard_arrow_right,
                                      color: Color.fromARGB(255, 22, 22, 22),
                                      size: 30.0),
                                  title: Text(
                                    'ผุ้เยี่ยม :${icarereports[index].fullname}',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 7, 7, 7),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'วันที่เยี่ยม ${icarereports[index].visit_date}',
                                  )),
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
                      title: 'กรุณาเพิิ่มข้อมูลการเยี่ยมด้วยค่ะ',
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
                  builder: ((context) => addsmvisit(
                        cid: widget.cid,
                        name:widget.name
                      )))).then((value) => loadmemberfromapi());
        },
        child: Text('เพิ่ม'),
      ),
    );
  }
}
