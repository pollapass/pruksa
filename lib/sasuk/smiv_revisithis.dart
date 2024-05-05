import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/smiv_revisit_model.dart';
import 'package:pruksa/sasuk/add_smivrevisit.dart';
import 'package:pruksa/sasuk/edit_smivrevisit.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class simvrevisthis extends StatefulWidget {
  final String cid;
  final String fullname;
  const simvrevisthis({Key? key, required this.cid, required this.fullname})
      : super(key: key);

  @override
  State<simvrevisthis> createState() => _simvrevisthisState();
}

class _simvrevisthisState extends State<simvrevisthis> {
  bool load = true;
  bool? haveData;
  List<smivrevisitmodel> revisitmodel = [];
  @override
  void initState() {
    // TODO: implement initState

    loadmemberfromapi();
    super.initState();

    // initialFile();
  }

  Future<Null> loadmemberfromapi() async {
    if (revisitmodel.length != 0) {
      revisitmodel.clear();
    } else {}
    String cid = widget.cid;
    print('cid is $cid');
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getsmrevisit.php?isAdd=true&id=$cid';
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการเยียม  ${widget.fullname}'),
      ),
      body: load
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
                                  color: Color.fromRGBO(242, 244, 247, 0.898)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => editsmivrevisit(
                                          smivModel: revisitmodel[index],
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
                                          ('${MyConstant.domain}/dopa/resource/smivrevisit/images/${revisitmodel[index].images}'))),
                                ),
                                title:
                                    // subtitle: Text(usermodels[index].user_phone),
                                    Row(
                                  children: <Widget>[
                                    Icon(Icons.date_range_rounded,
                                        color: Color.fromARGB(255, 11, 11, 11)),
                                    Text(
                                        'วันที่เยี่ยม ${revisitmodel[index].visit_date}',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 28, 28, 28))),
                                  ],
                                ),
                                subtitle: Text(
                                  'คะแนน ${revisitmodel[index].total}',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 7, 7, 7),
                                      fontWeight: FontWeight.bold),
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
                  builder: ((context) => addsmivrevisit(
                        cid: widget.cid,
                        fullname: widget.fullname,
                      )))).then((value) => loadmemberfromapi());
        },
        child: Text('เพิ่ม'),
      ),
    );
  }
}
