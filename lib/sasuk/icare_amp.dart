import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:pruksa/models/icare_model.dart';
import 'package:pruksa/sasuk/add_icare.dart';
import 'package:pruksa/sasuk/icare_report.dart';
import 'package:pruksa/utility/my_constant.dart';

class icareamp extends StatefulWidget {
  const icareamp({Key? key}) : super(key: key);

  @override
  State<icareamp> createState() => _icareampState();
}

class _icareampState extends State<icareamp> {
  bool load = true;
  bool? haveData;
  List<icaremodel> icaremodels = [];
  List<icaremodel> _foundicare = [];
  TextEditingController titelController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    loadmemberfromapi();
    _foundicare = icaremodels;
    // initialFile();
  }

  Future<Null> loadmemberfromapi() async {
    if (icaremodels.length != 0) {
      icaremodels.clear();
    } else {}
    String apigetmemberlist = '${MyConstant.domain}/dopa/api/geticareall.php';
    await Dio().get(apigetmemberlist).then((value) {
      // print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;

        });
      } else {

        for (var item in json.decode(value.data)) {
          icaremodel model = icaremodel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            icaremodels.add(model);
          });
        }

      }
    });
  }

  void _runfitter(String enterkeyword) {
    List<icaremodel> result = [];
    if (enterkeyword.isEmpty) {
      result = icaremodels;
    } else {
      result = icaremodels
          .where((icare) =>
              icare.fullname.toLowerCase().contains(enterkeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundicare = result;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลกลุ่มเปราะบาง'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          BuildTitel(),
          Buildmember()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => addicare())))
              .then((value) => loadmemberfromapi());
        },
        child: Text('เพิ่ม'),
      ),
    );
  }

  Container BuildTitel() {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.blueGrey, blurRadius: 5)],
      ),
      child: TextFormField(
        controller: titelController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อชื่อ';
          } else {
            return null;
          }
        },
        onChanged: (value) => _runfitter(value),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกชื่อเรื่อง',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Expanded Buildmember() {
    return Expanded(
      child: Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _foundicare.length,
            itemBuilder: (context, index) => Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
                              builder: (context) => icarereport(
                                fullname: _foundicare[index].fullname,
                                cid: _foundicare[index].cid,
                              ),
                            )).then((value) => loadmemberfromapi());
                      },
                      trailing: Icon(Icons.keyboard_arrow_right,
                          color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
                      leading: Container(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                ('${MyConstant.domain}/dopa/resource/icare/images/${_foundicare[index].icare_photo}'))),
                      ),
                      title: Text(
                        '${_foundicare[index].fullname}'
                        ' '
                        '${_foundicare[index].cid}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 7, 7, 7),
                            fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text(usermodels[index].user_phone),
                      subtitle: Text(
                        'ที่อยู่:${_foundicare[index].address} หมู่ที่ ${_foundicare[index].moopart} ${_foundicare[index].tfullname}',
                        style: MyConstant().h3RedStyle(),
                      ),
                    ),
                  ),
                )
            //
            ),
      ),
    );
  }
}
