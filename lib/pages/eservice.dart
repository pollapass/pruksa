import 'package:flutter/material.dart';
import 'package:pruksa/pages/add_damrong.dart';
import 'package:pruksa/pages/add_disaster.dart';
import 'package:pruksa/pages/add_informrisk.dart';
import 'package:pruksa/pages/add_redcross.dart';
import 'package:pruksa/pages/bora_service.dart';
import 'package:pruksa/pages/dopa_debt.dart';
import 'package:pruksa/service/edoe.dart';
import 'package:pruksa/service/gpro.dart';
import 'package:pruksa/service/landmap.dart';
import 'package:pruksa/service/nhso.dart';
import 'package:pruksa/service/papa.dart';
import 'package:pruksa/service/pasusad.dart';
import 'package:pruksa/service/pea.dart';
import 'package:pruksa/service/smartjobservice.dart';
import 'package:pruksa/service/sso40.dart';
import 'package:pruksa/service/ssojob.dart';
import 'package:pruksa/service/wellfare.dart';
import 'package:pruksa/utility/my_constant.dart';

class Eservice extends StatefulWidget {
  const Eservice({Key? key}) : super(key: key);

  @override
  State<Eservice> createState() => _EserviceState();
}

class _EserviceState extends State<Eservice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('บริการออนไลน์'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(
            'กระทรวงมหาดไทย',
            style: MyConstant().h1Style(),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset(MyConstant.imgdopa),
            ),
            title: Text('ลงทะเบียนแก้ไขหนี้นอกระบบ'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DopaDebt()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset(MyConstant.imgdopa),
            ),
            title: Text('แจ้งจุดเสี่ยง'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddInformRisk()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset(MyConstant.imgdopa),
            ),
            title: Text('ตรวจสอบชื่อ-\นามสกุลเบื้องต้น'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BoraService()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset(MyConstant.imgdisaster),
            ),
            title: Text('แจ้งสาธารณภัย'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDisaster()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset(MyConstant.imgdamrong),
            ),
            title: Text('ร้องทุกข์ร้องเรียน'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDamrong()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset(MyConstant.imgredcross),
            ),
            title: Text('ขอรับสนับสนุนจากกาชาด'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRedcross()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/papa.png'),
            ),
            title: Text('ขอใช้น้ำประปา'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PapaService()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/pea.png'),
            ),
            title: Text('ขอใช้ไฟฟ้า'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PeaService()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/land.jpg'),
            ),
            title: Text('ระบบค้นหาแปลงรุปที่ดิน'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => landmapservice()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          Text(
            'กระทรวงแรงงาน',
            style: MyConstant().h1Style(),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/job.jpg'),
            ),
            title: Text('ขึ้นทะเบียนคนว่างงาน'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Edoe()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/job.jpg'),
            ),
            title: Text('ระบบค้นหางานทำและคนหางาน'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SmartjobService()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/sso.png'),
            ),
            title: Text('ขึ้นทะเบียนผู้ประกันตนตามมาตรา 40'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SsoService()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/sso.png'),
            ),
            title: Text('ขอรับประโยชน์ทดแทนกรณีว่างงาน'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SsojobService()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          Text(
            'บริการผู้ประกอบธุรกิจ/SMEs',
            style: MyConstant().h1Style(),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/gpro.png'),
            ),
            title: Text('ลงทะเบียนผู้ค้ากับภาครัฐ'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GproService()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/pasusad.jpg'),
            ),
            title: Text('แจ้งโรคระบาดสัตว์'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pasusadservicw()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          Text(
            'บริการอื่นๆ',
            style: MyConstant().h1Style(),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/gpro.png'),
            ),
            title: Text('ตรวจสอบสิทธิบริการประกันสังคม'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Wellfare()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
          ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.asset('images/gpro.png'),
            ),
            title: Text('ตรวจสอบสิทธิการรักษาพยาบาล'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NhsoService()),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
          ),
        ],
      ),
    );
  }
}
