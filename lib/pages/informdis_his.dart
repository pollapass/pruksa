import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/informdis_model.dart';
import 'package:pruksa/pages/disaster_detail.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../wigets/show_progress.dart';
import '../wigets/show_titel.dart';

class InformDisHis extends StatefulWidget {
  const InformDisHis({Key? key}) : super(key: key);

  @override
  State<InformDisHis> createState() => _InformDisHisState();
}

class _InformDisHisState extends State<InformDisHis> {
  bool? haveData;
  bool load = true;
  List<InformDisModel> dismodels = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (dismodels.length != 0) {
      dismodels.clear();
    } else {}
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('cid')!;
    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getdis.php?isAdd=true&id=$id';

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
          InformDisModel model = InformDisModel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            dismodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการแจ้งสาธารณภัย'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: dismodels.length,
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
                                    builder: (context) => DisasterDetail(
                                      informdis: dismodels[index],
                                    ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    ('${MyConstant.domain}/images/disaster/${dismodels[index].inform_images}'),
                                placeholder: (context, url) => ShowProgress(),
                                errorWidget: (context, url, error) =>
                                    ShowImage(path: MyConstant.imgdopa),
                              ),
                            ),
                            title: Text(
                                'สถานที่เกิดภัย:${dismodels[index].inform_place}'),
                            subtitle: Text(
                              'สถานะ:${dismodels[index].status_name}',
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
          Navigator.pushNamed(context, MyConstant.routeAddinformdis)
              .then((value) => loadvaluefromapi());
        },

        //.then((value) => loadValueFromAPI()),
        child: Text('เพิ่ม'),
      ),
    );
  }
}
