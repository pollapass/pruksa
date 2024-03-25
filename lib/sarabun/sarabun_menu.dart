import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pruksa/pages/inform_news.dart';
import 'package:pruksa/pages/newpr_list.dart';
import 'package:pruksa/sarabun/booK_send.dart';

import 'package:pruksa/wigets/icon_menu.dart';
import 'package:pruksa/wigets/menu_item.dart';

class sarabunmenu extends StatefulWidget {
  const sarabunmenu({Key? key}) : super(key: key);

  @override
  State<sarabunmenu> createState() => _sarabunmenuState();
}

class _sarabunmenuState extends State<sarabunmenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบงานสารบัญ DEMO'),
      ),
      body: Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.all(10),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 30),
          children: [
            MenuItem(
                imagepath: 'images/news.png',
                titel: 'จัดการข่าว',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfromNews()),
                  );
                })),
            MenuItem(
                imagepath: 'images/pr.png',
                titel: 'ประกาศ',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewPrList()),
                  );
                })),
            iconsmenu(
                iconpath: FontAwesomeIcons.barcode,
                titel: 'หนังสือเวียน',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => booksend()),
                  );
                })),
          ],
        ),
      ),
    );
  }
}
