import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pruksa/models/paynews_model.dart';
import 'package:pruksa/sarabun/pay_newsdetail.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';

class paynewslist extends StatefulWidget {
  const paynewslist({Key? key}) : super(key: key);

  @override
  State<paynewslist> createState() => _paynewslistState();
}

class _paynewslistState extends State<paynewslist> {
  bool load = true;
  bool? haveData;
  List<paynewsModel> newsmodels = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadvaluefromapi();
    // checkPermission();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (newsmodels.length != 0) {
      newsmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getpaynews.php?isAdd=true';
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
          paynewsModel model = paynewsModel.fromMap(item);
          print('name of titel =${model.book_name}');

          setState(() {
            load = false;
            haveData = true;
            newsmodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ประกาศจัดซื้อจัดจ้าง'),
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
                                    builder: (context) => paynewsdetail(
                                        pdfurl:
                                            '${MyConstant.domain}/document/pay/${newsmodels[index].doc_key}',
                                        titel:
                                            '${newsmodels[index].book_name}'),
                                  )).then((value) => loadvaluefromapi());
                            },
                            title: Text(
                              '${newsmodels[index].book_name}',
                              style: MyConstant().gh2Style(),
                            ),
                            subtitle: Text(
                              '${newsmodels[index].dep_name}',
                              style: MyConstant().h2Style(),
                            ),
                             trailing: const FaIcon(FontAwesomeIcons.filePdf,
                              color: Color.fromARGB(255, 43, 37, 54),
                              size: 24.0),
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
