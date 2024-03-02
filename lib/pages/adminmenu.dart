import 'package:flutter/material.dart';
import 'package:pruksa/pages/active_menu.dart';
import 'package:pruksa/pages/damrong_all.dart';
import 'package:pruksa/pages/disaster_all.dart';
import 'package:pruksa/pages/informrisk_all.dart';
import 'package:pruksa/utility/my_constant.dart';
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
          title: Text('ระบบ'),
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
                  onTap: () {}),
              MenuItem(
                  imagepath: 'images/appoint.png',
                  titel: 'ระบบคิว',
                  onTap: () {}),
              MenuItem(
                  imagepath: 'images/book.png',
                  titel: 'หนังสือเวียน',
                  onTap: () {}),
              MenuItem(
                  imagepath: 'images/dopa.png',
                  titel: 'กำนัน ผู้ใหญ่บ้าน',
                  onTap: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ActiveMenu()),
                    );
                  }),
            ],
          ),
        ));
  }
}
