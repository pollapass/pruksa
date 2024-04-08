import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:pruksa/models/newspr_model.dart';
import 'package:pruksa/pages/edit_newpr.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class NewPrList extends StatefulWidget {
  const NewPrList({Key? key}) : super(key: key);

  @override
  State<NewPrList> createState() => _NewPrListState();
}

class _NewPrListState extends State<NewPrList> {
  bool load = true;
  bool? haveData;
  List<NewsprModel> newsmodels = [];

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
        title: Text('คำสั่ง ประกาศ'),
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
                                  builder: (context) => EditNewpr(

                                     newprModels: newsmodels[index],
                                  ),
                                )).then((value) => loadvaluefromapi());
                          },
                title: Text('${newsmodels[index].book_name}',style: MyConstant().gh2Style(),),
                            subtitle: Text('${newsmodels[index].dep_name}',style: MyConstant().h2Style(),),
                          trailing: const FaIcon(FontAwesomeIcons.penFancy,
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
                      title: 'ไม่มีประกาศค่ะ',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeAddpr)
              .then((value) => loadvaluefromapi());
        },

        //.then((value) => loadValueFromAPI()),
        child: Text('เพิ่ม'),
      ),
    );
  }
}
