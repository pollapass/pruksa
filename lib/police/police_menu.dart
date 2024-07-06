import 'package:flutter/material.dart';
import 'package:pruksa/pages/informrisk_all.dart';
import 'package:pruksa/sarabun/sarabun_menu.dart';
import 'package:pruksa/sasuk/smiv_amp.dart';
import 'package:pruksa/wigets/menu_item.dart';

class policemenu extends StatefulWidget {
  const policemenu({Key? key}) : super(key: key);

  @override
  State<policemenu> createState() => _policemenuState();
}

class _policemenuState extends State<policemenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบงานสภ.บ้านหลวง'),
      ),
      body: Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.all(10),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 30),
          children: [
            MenuItem(
                imagepath: 'images/pol.jpg',
                titel: 'ข้อมูลจุดเสี่ยง',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InformRiskAll()),
                  );
                })),
            MenuItem(
                imagepath: 'images/pol.jpg',
                titel: 'ผุ้ป่วยจิตเวช',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => smvamp()),
                  );
                })),
            MenuItem(
                imagepath: 'images/book.png',
                titel: 'งานสารบัญ',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => sarabunmenu()));
                }),
          ],
        ),
      ),
    );
  }
}
