import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/redcross_model.dart';
import 'package:pruksa/pages/edit_redcross.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class redcrossall extends StatefulWidget {
  const redcrossall({Key? key}) : super(key: key);

  @override
  State<redcrossall> createState() => _redcrossallState();
}

class _redcrossallState extends State<redcrossall> {
  bool? haveData;
  bool load = true;
  List<RedcrossModel> redmodels = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (redmodels.length != 0) {
      redmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getredcross.php?isAdd=true';

    await Dio().get(apigetactivelist).then((value) {
      print('value ==> $value');

      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          RedcrossModel model = RedcrossModel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            redmodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลขอรับการสนับสนุน'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: redmodels.length,
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
                                    builder: (context) => editredcross(
                                      redcrossmodels: redmodels[index],
                                    ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    ('${MyConstant.domain}/images/redcross/${redmodels[index].images}'),
                                placeholder: (context, url) => ShowProgress(),
                                errorWidget: (context, url, error) =>
                                    ShowImage(path: MyConstant.imgdopa),
                              ),
                            ),
                            title: Text(
                                'ประเภทความช่วยเหลือ:${redmodels[index].help_name}'),
                            subtitle: Text(
                              'สถานะ:${redmodels[index].status_name}',
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
