import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pruksa/pages/member_list%20copy.dart';
import 'package:pruksa/setting/requesst_user.dart';
import 'package:pruksa/wigets/icon_menu.dart';

class settingmenu extends StatelessWidget {
  const settingmenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตั้งค่าระบบ'),
      ),
      body: Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(10),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 30),
            children: [
              iconsmenu(
                  iconpath: FontAwesomeIcons.userGear,
                  titel: 'อนุญาติเข้าระบบ',
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => requestuser()),
                    );
                  })),
            ],
          )),
    );
  }
}
