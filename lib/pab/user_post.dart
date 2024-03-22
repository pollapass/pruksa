import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/pab/view_post_screen.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPost extends StatefulWidget {
  final String name;
  final String photo;
  final String titel;
  final String act_key;
  final String user_photo;
  final String detail;
  final String act_date;

  final String itemsname;
  const UserPost(
      {Key? key,
      required this.name,
      required this.itemsname,
      required this.photo,
      required this.titel,
      required this.detail,
      required this.user_photo,
      required this.act_date,
      required this.act_key})
      : super(key: key);

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
    List<String> groupList = [];

  var total;
  var like;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    loadcommentFromAPI();
    loadlikeFromAPI();
    // initialFile();
  }

  Future<Null> loadcommentFromAPI() async {
    String id = widget.act_key;
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

  Future<Null> loadlikeFromAPI() async {
    String id = widget.act_key;
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

////////////////
  Future<Null> checklike() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userkey = preferences.getString('id')!;
    String act_key = widget.act_key;

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
            loadlikeFromAPI();
          } else {
            MyDialog().normalDialog(
                context, 'ไม่สามารถกด Like ได้ !!!', 'Please Try Again');
          }
        });
      } else {}
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
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
                          image: NetworkImage((widget.user_photo)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Text(widget.act_date,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // print('act_key is $act_key');
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPostScreen(
                                    activekey: widget.act_key,
                                    titel: widget.titel,
                                    user_photo: widget.user_photo,
                                    name: widget.name,
                                    act_date: widget.act_date,
                                    itemsname: widget.itemsname,
                                    detail: widget.detail,
                                    photo: widget.photo)))
                        .then((value) => loadcommentFromAPI());
                  })
            ],
          ),
        ),
        InkWell(
          onDoubleTap: () => print('Like post'),
          onTap: () {},
          child: Container(
            margin: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 200.0,
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
                image: NetworkImage((widget.photo)),
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
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPostScreen(
                                          activekey: widget.act_key,
                                          titel: widget.titel,
                                          user_photo: widget.user_photo,
                                          name: widget.name,
                                          act_date: widget.act_date,
                                          itemsname: widget.itemsname,
                                          detail: widget.detail,
                                          photo: widget.photo)))
                              .then((value) => loadcommentFromAPI());
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
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ด้าน : ${widget.itemsname}'),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0, left: 16.0),
          child: Row(
            children: [
              Text('ถูกใจโดย'),
              Text(
                widget.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('และ'),
              Text(
                'คนอื่นๆ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 8),

          //padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: ':',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: widget.titel,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}