import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pruksa/pages/news.dart';

import 'package:pruksa/pages/newspr.dart';
import 'package:pruksa/sarabun/book_send_all.dart';
import 'package:pruksa/sarabun/pay_newslist.dart';
import 'package:pruksa/wigets/icon_menu.dart';
import 'package:pruksa/wigets/menu_item.dart';

class bookbox extends StatefulWidget {
  const bookbox({Key? key}) : super(key: key);

  @override
  State<bookbox> createState() => _bookboxState();
}

class _bookboxState extends State<bookbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('กล่องหนังสือ')),
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
                    MaterialPageRoute(builder: (context) => News()),
                  );
                })),
            MenuItem(
                imagepath: 'images/pr.png',
                titel: 'ประกาศ',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsPr()),
                  );
                })),
           
                    iconsmenu(
                iconpath: FontAwesomeIcons.bookBookmark,
                titel: 'หนังสือเวียน',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => booksendall()),
                  );
                })),
                         iconsmenu(
                iconpath: FontAwesomeIcons.moneyBill1,
                titel: 'จัดซิ้อจัดจ้าง',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => paynewslist()),
                  );
                })),
            ],
          )),
    );
  }
}
