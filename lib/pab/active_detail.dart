import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/active_list_model.dart';
import 'package:pruksa/models/comment_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveDetail extends StatefulWidget {
  final ActiveListModel activeModel;
  const ActiveDetail({Key? key, required this.activeModel}) : super(key: key);

  @override
  State<ActiveDetail> createState() => _ActiveDetailState();
}

class _ActiveDetailState extends State<ActiveDetail> {
   ActiveListModel? activeModel;
  bool load = true;
  bool? haveData;
  String? avatar;
  var total;
  var like;
  List<CommentModel> listmodel = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeModel = widget.activeModel;
    loadcommentfromapi();
    countcommentFromAPI();
    countlikeFromAPI();
    //print('### image from mySQL ==>> ${activeModel!.act_key}');
    finduser();

    // initialFile();
  }

  Future<Null> finduser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      avatar = preferences.getString('user_photo');
    });
  }

  Future<Null> countcommentFromAPI() async {
    String id = activeModel!.act_key;
    print(id);
    String apiGetActiveGroup =
        '${MyConstant.domain}/dopa/api/getcountcomment.php?isAdd=true&id=$id';
    await Dio().get(apiGetActiveGroup).then((value) {
      var item = json.decode(value.data);

      setState(() {
        // print(item[0]['total']);

        total = item[0]['total'];
        //print(total);
      });
    });
    //print(poslist);
  }

  Future<Null> checklike() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userkey = preferences.getString('id')!;
    String act_key = activeModel!.act_key;

    String apiCheckAuthen =
        '${MyConstant.domain}/dopa/api/checklike.php?isAdd=true&userkey=$userkey&act_key=$act_key';
    await Dio().get(apiCheckAuthen).then((value) async {
      print('## value for API ==>> $value');
      if (value.toString() == 'null') {
        String apiInsertActReport =
            '${MyConstant.domain}/dopa/api/insertlike.php?isAdd=true&user_key=$userkey&act_key=$act_key';
        await Dio().get(apiInsertActReport).then((value) {
          if (value.toString() == 'true') {
            //loadcommentfromapi();
            countlikeFromAPI();
          } else {
            MyDialog().normalDialog(
                context, 'ไม่สามารถกด Like ได้ !!!', 'Please Try Again');
          }
        });
      } else {}
    });
  }

  Future<Null> countlikeFromAPI() async {
    String id = activeModel!.act_key;
    String apiGetActiveGroup =
        '${MyConstant.domain}/dopa/api/getcountlike.php?isAdd=true&id=$id';
    await Dio().get(apiGetActiveGroup).then((value) {
      var item = json.decode(value.data);

      setState(() {
        // print(item[0]['total']);

        like = item[0]['total'];
        //print(total);
      });
    });
    //print(poslist);
  }

  Future<Null> loadcommentfromapi() async {
    if (listmodel.length != 0) {
      listmodel.clear();
    } else {}
    String id = activeModel!.act_key;
    print('id = $id');
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getcomment.php?isAdd=true&id=$id';
    await Dio().get(apigetmemberlist).then((value) {
      print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          CommentModel model = CommentModel.fromMap(item);
          //print('name of titel =${model.titel}');
          //String name = model.titel;
          setState(() {
            load = false;
            haveData = true;
            listmodel.add(model);
          });
        }
      }
    });
  }

  Future<Null> addcomment() async {
    String name = nameController.text;

    String id = activeModel!.act_key;

    // ignore: unnecessary_null_comparison
    if (name == null) {
      MyDialog().normalDialog(context, 'ข้อมูลไม่ครบ', 'กรอกข้อมูลให้ครบ');
    } else {
      SharedPreferences preference = await SharedPreferences.getInstance();

      String userkey = preference.getString('id')!;
      String apiInsertActReport =
          '${MyConstant.domain}/dopa/api/insertcomment.php?isAdd=true&user_key=$userkey &titel=$name&act_key=$id';
      await Dio().get(apiInsertActReport).then((value) {
        if (value.toString() == 'true') {
          //loadcommentfromapi();
          // Navigator.pop(context);

          setState(() {
            loadcommentfromapi();
          });
        } else {
          MyDialog().normalDialog(
              context, 'Create New User False !!!', 'Please Try Again');
        }
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดผลการปฎิบัติงาน',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyConstant.primary,
      ),
      body: SingleChildScrollView(
        //physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40.0),
              width: double.infinity,
              height: 600.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 1.0,
                              child: ListTile(
                                leading: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 2),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      child: Image(
                                        height: 50.0,
                                        width: 50.0,
                                        image: NetworkImage(
                                            '${MyConstant.domain}/dopa/resource/users/images/${activeModel!.user_photo}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      activeModel!.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      activeModel!.lastname,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(''),
                                trailing: Text(activeModel!.act_date),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onDoubleTap: () => print('Like post'),
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            width: double.infinity,
                            height: 400.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 5),
                                  blurRadius: 8.0,
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${MyConstant.domain}dopa/resource/active/images/${activeModel!.act_images}'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.favorite_border),
                                        iconSize: 30.0,
                                        onPressed: () {
                                          checklike();
                                        },
                                      ),
                                      Text(
                                        '${like}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20.0),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.chat),
                                        iconSize: 30.0,
                                        onPressed: () {
                                          print('Chat');
                                        },
                                      ),
                                      Text(
                                        '${total}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.bookmark_border),
                                iconSize: 30.0,
                                onPressed: () => print('Save post'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('เรื่อง',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(activeModel!.titel),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'รายละเอียด',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: ':',
                        style: TextStyle(color: Colors.black),
                      ),
                    ])),
                    Text(
                      activeModel!.act_detail,
                      softWrap: true,
                      maxLines: 10,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 600.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: load
                    ? ShowProgress()
                    : haveData!
                        ? ListView.builder(
                            itemCount: listmodel.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  child: ClipOval(
                                    child: Image(
                                      height: 50.0,
                                      width: 50.0,
                                      image: NetworkImage(
                                          ('${MyConstant.domain}/dopa/resource/users/images/${listmodel[index].user_photo}')),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                '${listmodel[index].fullname}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('${listmodel[index].com_detail}'),
                              trailing: Text('${listmodel[index].com_date}'),
                            ),
                            //
                          )
                        : Column(
                            children: [
                              ShowTitle(
                                title: 'ไม่มีข้อมูล',
                                textStyle: MyConstant().h2RedStyle(),
                              ),
                              ShowTitle(
                                title: 'ไม่มี comment ในระบบ',
                                textStyle: MyConstant().h2RedStyle(),
                              ),
                            ],
                          ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.all(20.0),
                  hintText: 'เพิ่มความคิดเห็น',
                  prefixIcon: Container(
                    margin: EdgeInsets.all(4.0),
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          height: 48.0,
                          width: 48.0,
                          image: NetworkImage(
                              '${MyConstant.domain}/dopa/resource/users/images/$avatar'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: Container(
                    margin: EdgeInsets.only(right: 4.0),
                    width: 70.0,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.arrow_forward), //icon data for elevated button
                      label: Text(""),
                      onPressed: () {
                        addcomment();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: MyConstant.primary
               //elevated btton background color
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}