import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:pruksa/models/newspr_model.dart';
import 'package:pruksa/pages/newpr_detail.dart';
import 'package:pruksa/wigets/show_progress.dart';

import '../utility/my_constant.dart';

class NewsPr extends StatefulWidget {
  const NewsPr({Key? key}) : super(key: key);

  @override
  State<NewsPr> createState() => _NewsPrState();
}

class _NewsPrState extends State<NewsPr> {
  bool load = true;
  bool? haveData;
  List<NewsprModel> newsmodels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();

    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (newsmodels.length != 0) {
      newsmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getnewspr.php?isAdd=true';
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
          NewsprModel model = NewsprModel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            newsmodels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ประกาศ คำสั่ง'),
        ),
        body: load
            ? ShowProgress()
            : haveData!
                ? ListView.builder(
                    itemCount: newsmodels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(246, 242, 247, 0.894)),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => newprdetail(
                                      pdfurl:
                                          '${MyConstant.domain}/document/pr/${newsmodels[index].doc_key}',
                                          titel:'${newsmodels[index].book_name}'
                                    ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            title: Text('${newsmodels[index].book_name}',style: MyConstant().gh2Style(),),
                            subtitle: Text('${newsmodels[index].dep_name}',style: MyConstant().h2Style(),),
                          ),
                        ),
                        //  fileUrl: '${MyConstant.domain}/document/pr/${newsmodels[index].doc_key}',

                        //title: newsmodels[index].book_name,
                      );
                    })
                : TextButton(
                    onPressed: () {}, child: const Text("ไม่มีการประกาศค่ะ")));
  }
}
