import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/active_list_model.dart';
import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/pab/active_detail.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class MemberReport extends StatefulWidget {
  final UserModel userModels;
  const MemberReport({Key? key, required this.userModels}) : super(key: key);
  @override
  State<MemberReport> createState() => _MemberReportState();
}

class _MemberReportState extends State<MemberReport> {
    UserModel? userModels;
  bool load = true;
  bool? haveData;
  List<ActiveListModel> activelistmodels = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModels = widget.userModels;
    // print('### image from mySQL ==>> ${userModel!.user_key}');
    loadvaluefromapi();
  }

  Future<Null> loadvaluefromapi() async {
    if (activelistmodels.length != 0) {
      activelistmodels.clear();
    } else {}

    String id = userModels!.user_key.toString();
    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getActivereportWhereid.php?isAdd=true&id=$id';
    await Dio().get(apigetactivelist).then((value) {
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

  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
          title: Text(
            'ผลการปฎิบัติงานของ  ${userModels!.fullname}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyConstant.primary,
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
                                color: Color.fromRGBO(242, 244, 247, 0.898)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActiveDetail(
                                        activeModel: activelistmodels[index],
                                      ),
                                    )).then((value) => loadvaluefromapi());
                              },
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Color.fromARGB(255, 22, 22, 22),
                                  size: 30.0),
                              leading: Container(
                                  width: 60,
                                  height: 60,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        ('${MyConstant.domain}/dopa/resource/active/images/${activelistmodels[index].act_images}'),
                                    placeholder: (context, url) =>
                                        ShowProgress(),
                                    errorWidget: (context, url, error) =>
                                        ShowImage(path: MyConstant.imgdopa),
                                  )),
                              subtitle: Text(
                                  'ผลงาน :'
                                  '${activelistmodels[index].titel}',
                                  style: MyConstant().h3Style()),
                              title: Row(
                                children: [
                                  Icon(Icons.date_range,
                                      color: Color.fromARGB(255, 11, 11, 11)),
                                  Text(activelistmodels[index].act_date),
                                ],
                              ),
                            ),
                          ),
                        )
                    //
                    )
                : Column(
                    children: [
                      ShowTitle(
                        title: 'ไม่มีผลการปฎิบัติงาน',
                        textStyle: MyConstant().h2RedStyle(),
                      ),
                    ],
                  )
    );
  }
}