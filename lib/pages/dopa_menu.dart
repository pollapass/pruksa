import 'package:flutter/material.dart';
import 'package:pruksa/pab/palad_main.dart';
import 'package:pruksa/pages/active_menu.dart';
import 'package:pruksa/pages/appoint_list.dart';
import 'package:pruksa/pages/damrong_all.dart';
import 'package:pruksa/pages/disaster_all.dart';
import 'package:pruksa/pages/informrisk_all.dart';
import 'package:pruksa/pages/redcross_all.dart';
import 'package:pruksa/sarabun/sarabun_menu.dart';
import 'package:pruksa/sasuk/smiv_amp.dart';
import 'package:pruksa/wigets/menu_item.dart';

class dopamenu extends StatefulWidget {
  const dopamenu({Key? key}) : super(key: key);

  @override
  State<dopamenu> createState() => _dopamenuState();
}

class _dopamenuState extends State<dopamenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบงานอำเภอบ้านหลวง '),
      ),
      body: Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(10),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 30),
            children: [
             
              MenuItem(
                  imagepath: 'images/dopa.png',
                  titel: 'ข้อมูลจุดเสี่ยง',
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InformRiskAll()),
                    );
                  })),
              MenuItem(
                  imagepath: 'images/disaster.jpg',
                  titel: 'สาธารณภัย',
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisasterAll()),
                    );
                  })),
              MenuItem(
                  imagepath: 'images/damrong.jpg',
                  titel: 'ศูนย์ดำรงธรรม',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DamrongAll()),
                    );
                  }),
              MenuItem(
                  imagepath: 'images/redcross.jpg',
                  titel: 'กาชาด',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => redcrossall()),
                    );
                  }),
              MenuItem(
                  imagepath: 'images/appoint.png',
                  titel: 'ระบบคิว',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AppointList()));
                  }),
              MenuItem(
                  imagepath: 'images/book.png',
                  titel: 'งานสารบัญ',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => sarabunmenu()));
                  }),
              MenuItem(
                  imagepath: 'images/dopa.png',
                  titel: 'กำนัน ผู้ใหญ่บ้าน',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => paladmain()),
                    );
                  }),
                      MenuItem(
                  imagepath: 'images/dopa.png',
                  titel: 'ผู้ป่วยจิตเวช',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => smvamp()),
                    );
                  }),
            ],
          )),
    );
  }
}
