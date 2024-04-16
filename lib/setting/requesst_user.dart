import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/model_user.dart';
import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/setting/edit_requser.dart';
import 'package:pruksa/utility/my_constant.dart';

class requestuser extends StatefulWidget {
  const requestuser({Key? key}) : super(key: key);

  @override
  State<requestuser> createState() => _requestuserState();
}

class _requestuserState extends State<requestuser> {
  bool load = true;
  bool? haveData;
  List<Modeluser> usermodels = [];
  List<Modeluser> _searchResult = [];

  //List<Map<String,dynamic>> items = [];
  //List<Map<String,dynamic>> founduser = [];
  TextEditingController titelController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    super.initState();
    loadmemberfromapi();
    _searchResult = usermodels;
    // initialFile();
  }

  Future<Null> loadmemberfromapi() async {
    if (usermodels.length != 0) {
      usermodels.clear();
    } else {}
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getrequser.php?isAdd=true';
    await Dio().get(apigetmemberlist).then((value) {
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
          Modeluser model = Modeluser.fromMap(item);
          print('name of titel =${model.fullname}');

          setState(() {
            load = false;
            haveData = true;
            usermodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ทะเบียนผู้ขอใช้งานในระบบ'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          BuildTitel(),
          Buildmember()
        ],
      ),
    );
  }

  void _runfitter(String enterkeyword) {
    List<Modeluser> result = [];
    if (enterkeyword.isEmpty) {
      result = usermodels;
    } else {
      result = usermodels
          .where((icare) =>
              icare.fullname.toLowerCase().contains(enterkeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _searchResult = result;
    });
  }

  Container BuildTitel() {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.blueGrey, blurRadius: 5)],
      ),
      child: TextFormField(
        controller: titelController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อชื่อ';
          } else {
            return null;
          }
        },
        onChanged: (value) => _runfitter(value),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกชื่อเรื่อง',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Expanded Buildmember() {
    return Expanded(
      child: Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _searchResult.length,
            itemBuilder: (context, index) => Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
                              builder: (context) => editrequser(
                                appointModels: _searchResult[index],
                                //     icaremodels: icarereports[index],
                                // Icaremodels: icaremodels.,
                              ),
                            )).then((value) => loadmemberfromapi());
                      },
                      trailing: Icon(Icons.keyboard_arrow_right,
                          color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
                      leading: Container(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                ('${MyConstant.domain}/dopa/resource/users/images/${_searchResult[index].user_photo}'))),
                      ),
                      title: Text(
                        '${_searchResult[index].fullname}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 7, 7, 7),
                            fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text(usermodels[index].user_phone),
                      subtitle: Row(
                        children: <Widget>[
                          Text('${_searchResult[index].pos_name}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 28, 28, 28))),
                        ],
                      ),
                    ),
                  ),
                )
            //
            ),
      ),
    );
  }
}
