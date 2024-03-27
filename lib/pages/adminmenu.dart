import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pruksa/pages/active_menu.dart';
import 'package:pruksa/pages/appoint_list.dart';
import 'package:pruksa/pages/damrong_all.dart';
import 'package:pruksa/pages/disaster_all.dart';
import 'package:pruksa/pages/informrisk_all.dart';
import 'package:pruksa/pages/redcross_all.dart';
import 'package:pruksa/pages/show_meet.dart';
import 'package:pruksa/sarabun/sarabun_menu.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/icon_menu.dart';
import 'package:pruksa/wigets/menu_item.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({Key? key}) : super(key: key);

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('เมนูหลัก '),
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
                      MaterialPageRoute(builder: (context) => ActiveMenu()),
                    );
                  }),
              MenuItem(
                  imagepath: 'images/dopa.png',
                  titel: 'ห้องประชุม',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => showmeeting()),
                    );
                  }),
              MenuItem(
                  imagepath: 'images/webboard.png',
                  titel: 'กล่องหนังสือ',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => sarabunmenu()),
                    );
                  }),
                    MenuItem(
                  imagepath: 'images/sasuk.png',
                  titel: 'สาธารณสุข',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => sarabunmenu()),
                    );
                  }),
              iconsmenu(
                  iconpath: FontAwesomeIcons.gears,
                  titel: 'ตั้งค่าระบบ',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => showmeeting()),
                    );
                  })
            ],
          ),
        ));
  }
}
