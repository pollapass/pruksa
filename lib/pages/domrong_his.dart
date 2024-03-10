import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/damrong_model.dart';
import 'package:pruksa/pages/damrong_detail.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../wigets/show_image.dart';
import '../wigets/show_progress.dart';
import '../wigets/show_titel.dart';

class DomrongHis extends StatefulWidget {
  const DomrongHis({Key? key}) : super(key: key);

  @override
  State<DomrongHis> createState() => _DomrongHisState();
}

class _DomrongHisState extends State<DomrongHis> {
  bool? haveData;
  bool load = true;
  List<DamrongModels> dammodels = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (dammodels.length != 0) {
      dammodels.clear();
    } else {}
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('cid')!;
    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getdamrong.php?isAdd=true&id=$id';

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
          DamrongModels model = DamrongModels.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            dammodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการร้องทุกข์ร้องเรียน'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: dammodels.length,
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
                                    builder: (context) => DamrongDetail(
                                      Damrong: dammodels[index],
                                    ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    ('${MyConstant.domain}/images/damrong/${dammodels[index].contact_images}'),
                                placeholder: (context, url) => ShowProgress(),
                                errorWidget: (context, url, error) =>
                                    ShowImage(path: MyConstant.imgdamrong),
                              ),
                            ),
                            title: Text(
                                'เรื่อง:${dammodels[index].contact_title}'),
                            subtitle: Text(
                              'สถานะ:${dammodels[index].status_name}',
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
                      title: 'ไม่มีประวัติการแจ้ง',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeAdddamrong)
              .then((value) => loadvaluefromapi());
        },

        //.then((value) => loadValueFromAPI()),
        child: Text('เพิ่ม'),
      ),
    );
  }
}
