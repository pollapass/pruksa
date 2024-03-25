import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pruksa/models/book_send_model.dart';
import 'package:pruksa/sarabun/show_booksend.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class booksendall extends StatefulWidget {
  const booksendall({Key? key}) : super(key: key);

  @override
  State<booksendall> createState() => _booksendallState();
}

class _booksendallState extends State<booksendall> {
  bool load = true;
  bool? haveData;

  List<booksendmodels> _bookmodels = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    //loadvaluefromapi();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (_bookmodels.length != 0) {
      _bookmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getbooksend.php?isAdd=true';

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
          booksendmodels model = booksendmodels.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            _bookmodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หนังสือเวียนของท่าน'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: _bookmodels.length,
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
                                  builder: (context) => showbooksend(
                                      pdfurl:
                                          '${MyConstant.domain}/document/pr/${_bookmodels[index].doc_key}',
                                      titel: '${_bookmodels[index].book_name}'),
                                )).then((value) => loadvaluefromapi());
                          },
                          title: Text('${_bookmodels[index].book_name}'),
                          subtitle: Text('โดย:${_bookmodels[index].dep_name}'),
                          trailing: const FaIcon(FontAwesomeIcons.forward,
                              color: Color.fromARGB(255, 43, 37, 54),
                              size: 24.0),
                        ),
                      ),
                      //  fileUrl: '${MyConstant.domain}/document/pr/${newsmodels[index].doc_key}',

                      //title: newsmodels[index].book_name,
                    );
                  })
              : Column(
                  children: [
                    ShowTitle(
                      title: 'ไม่มีหนังสือเวียนค่ะ',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),
    );
  }
}
