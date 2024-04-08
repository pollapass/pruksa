import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/smiv_model.dart';
import 'package:pruksa/sasuk/edit_smivamp.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class smvamp extends StatefulWidget {
  const smvamp({Key? key}) : super(key: key);

  @override
  State<smvamp> createState() => _smvampState();
}

class _smvampState extends State<smvamp> {
  bool load = true;
  bool? haveData;
  List<smivmodel> smmodels = [];
 
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (smmodels.length != 0) {
      smmodels.clear();
    } else {}
    //  preferences.setString('addressid')!;
    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getsmivamp.php?isAdd=true';

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
          smivmodel model = smivmodel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            smmodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลส่งต่อจาก รพสต'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: smmodels.length,
                  itemBuilder: (context, index) => Card(
                        elevation: 10.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 242, 247, 0.894)),
                          child: ListTile(
                            onTap: () {
                              print('## You Click Edit');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => editsmivamp(
                                      smivModel: smmodels[index],
                                    ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    ('${MyConstant.domain}/images/smiv/${smmodels[index].sm_image}'),
                                placeholder: (context, url) => ShowProgress(),
                                errorWidget: (context, url, error) =>
                                    ShowImage(path: MyConstant.imgdopa),
                              ),
                            ),
                            title: Text('ชื่อ:${smmodels[index].sm_name}'),
                            subtitle: Text(
                              'ที่อยู่:${smmodels[index].address} หมู่ที่ ${smmodels[index].moopart}${smmodels[index].fulladdress}',
                              style: MyConstant().h3RedStyle(),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,
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
                      title: 'ไม่มีข้อมูลค่ะ',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),
    );
  }
}
