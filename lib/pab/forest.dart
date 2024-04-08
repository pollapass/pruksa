import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/forrest_model.dart';
import 'package:pruksa/pab/add_forrest.dart';
import 'package:pruksa/pab/forrest_edit.dart';
import 'package:pruksa/sarabun/add_booksend.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class forest extends StatefulWidget {
  const forest({Key? key}) : super(key: key);

  @override
  State<forest> createState() => _forestState();
}

class _forestState extends State<forest> {
  bool load = true;
  bool? haveData;
  List<forrest> forest = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (forest.length != 0) {
      forest.clear();
    } else {}
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String moopart =
        preferences.getString('moopart')!; //preferences.setString('moopart')!;
    String tmbpart = preferences
        .getString('addressid')!; //  preferences.setString('addressid')!;
    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getforestmoo.php?isAdd=true&moopart=$moopart&tmbpart=$tmbpart';

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
          forrest model = forrest.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            forest.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ทะเบียนคนขึ้นป่า'),
        backgroundColor: Colors.green,
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: forest.length,
                  itemBuilder: (context, index) => Card(
                        elevation: 10.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 242, 247, 0.894)),
                          child: ListTile(
                            onTap: () {
                              //print('## You Click Edit');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => editforrest(
                                        //smivModel: forest[index],
                                        ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    ('${MyConstant.domain}/images/smiv/${forest[index].images}'),
                                placeholder: (context, url) => ShowProgress(),
                                errorWidget: (context, url, error) =>
                                    ShowImage(path: MyConstant.imgdopa),
                              ),
                            ),
                            title: Text('ชื่อ:${forest[index].fullname}'),
                            subtitle: Text(
                              'ที่อยู่:${forest[index].address} หมู่ที่ ${forest[index].moopart} ${forest[index].fulladdress}',
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: ((context) => addforrest())))
            .then((value) => loadvaluefromapi()),
        child: Text('เพิ่ม'),
      ),
    );
  }
}
