import 'package:flutter/material.dart';
import 'package:pruksa/pab/smiv_moo.dart';
import 'package:pruksa/sarabun/sarabun_menu.dart';
import 'package:pruksa/sasuk/icare_amp.dart';
import 'package:pruksa/sasuk/smiv_amp.dart';
import 'package:pruksa/sasuk/smiv_tmb.dart';
import 'package:pruksa/wigets/menu_item.dart';

class sasukmenu extends StatefulWidget {
  const sasukmenu({Key? key}) : super(key: key);

  @override
  State<sasukmenu> createState() => _sasukmenuState();
}

class _sasukmenuState extends State<sasukmenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบงานสาธารณสุข'),
      ),
      body: Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(10),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 30),
            children: [
              MenuItem(
                  imagepath: 'images/sasuk.png',
                  titel: 'SMIV ตำบล',
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => smivtmb()),
                    );
                  })),
              MenuItem(
                  imagepath: 'images/sasuk.png',
                  titel: 'SMIV อำเภอ',
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => smvamp()),
                    );
                  })),
              MenuItem(
                  imagepath: 'images/sasuk.png',
                  titel: 'กลุ่มเปราะบาง',
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => icareamp()),
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
          )),
    );
  }
}
