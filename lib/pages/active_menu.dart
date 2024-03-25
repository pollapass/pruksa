import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pruksa/pab/active_list.dart';
import 'package:pruksa/pab/active_main.dart';
import 'package:pruksa/pab/dopa_list.dart';
import 'package:pruksa/report/act_mountreport.dart';
import 'package:pruksa/report/act_person_report.dart';
import 'package:pruksa/report/act_report.dart';
import 'package:pruksa/report/act_tmbreport.dart';
import 'package:pruksa/report/risk_report.dart';
import 'package:pruksa/wigets/icon_menu.dart';
import 'package:pruksa/wigets/menu_item.dart';

class ActiveMenu extends StatelessWidget {
  const ActiveMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบงานกำนัน ผู้ใหญ่บ้าน ฯ'),
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
                titel: 'ปกครองท้องที่',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => activeMain()),
                  );
                })),
            iconsmenu(
                iconpath: FontAwesomeIcons.clock,
                titel: 'ประวัติผลงาน',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActiveList()),
                  );
                })),
                   iconsmenu(
                iconpath:FontAwesomeIcons.users,
                titel: 'สมาชิก',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => dopalist()),
                  );
                })),
            MenuItem(
                imagepath: 'images/report.png',
                titel: 'แยกรายเดือน',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => actmountreport()),
                  );
                })),
            iconsmenu(
                iconpath: FontAwesomeIcons.react,
                titel: 'แยกตำบล',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => acttmbreport()),
                  );
                })),
         
            MenuItem(
                imagepath: 'images/report1.png',
                titel: 'TOPTEN',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => actreportperson()),
                  );
                }))
          ],
        ),
      ),
    );
  }
}
