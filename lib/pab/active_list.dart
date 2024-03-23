import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/active_list_model.dart';
import 'package:pruksa/pab/edit_active.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveList extends StatefulWidget {
  const ActiveList({Key? key}) : super(key: key);

  @override
  State<ActiveList> createState() => _ActiveListState();
}

class _ActiveListState extends State<ActiveList> {
  bool load = true;
  bool? haveData;

  List<ActiveListModel> activelistmodels = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (activelistmodels.length != 0) {
      activelistmodels.clear();
    } else {}
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getActivereportWhereid.php?isAdd=true&id=$id';
    await Dio().get(apigetactivelist).then((value) {
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
          ActiveListModel model = ActiveListModel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            activelistmodels.add(model);
          });
        }
      }
    });
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}${strings[0]}';
    return url;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการปฎิบัติงาน'),
      ),
            body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: activelistmodels.length,
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
                                    builder: (context) => EditActive(
                                      activeModel: activelistmodels[index],
                                    ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    ('${MyConstant.domain}/dopa/resource/active/images/${activelistmodels[index].act_images}'),
                                placeholder: (context, url) => ShowProgress(),
                                errorWidget: (context, url, error) =>
                                    ShowImage(path: MyConstant.imgdopa),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(activelistmodels[index].name),
                                Text(activelistmodels[index].lastname),
                              ],
                            ),
                            subtitle: Text(activelistmodels[index].titel),
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
                      title: 'ไม่มีข้อมูล',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                    ShowTitle(
                      title: 'กรุณากรอกข้อมูลการปฎิบัติงานด้วยค่ะ',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),

      // load เงื่อนไข ถ้าไม่ใช้ใช้คำว่า load finish

      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddactive),
        //.then((value) => loadValueFromAPI()),
        child: Text('เพิ่ม'),
      ),
    );
  
  }
}
