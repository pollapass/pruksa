import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pruksa/wigets/show_image.dart';

import '../utility/my_constant.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เกี่ยวกับโปรแกรม'),
       
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text('P Project version Pruksa',
              style: GoogleFonts.prompt(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          Container(
              padding: EdgeInsets.all(20),
             // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Image.asset(MyConstant.develop)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  'ผุ้พัฒนา',
                  textAlign: TextAlign.center,
                  // style: texrs,
                  style: MyConstant().h1blackStyle(),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'นายพลภัทร์  ประภัสระกูล',
            style: MyConstant().h3Style(),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'ปลัดอำเภอบ้านหลวง จังหวัดน่าน',
            style: MyConstant().h3Style(),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, left: 10),
            child: Text(
              'อำเภอบ้านหลวง E-service',
              textAlign: TextAlign.center,
              style: MyConstant().h2Style(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Version 1.0 ',
            style: MyConstant().h3Style(),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 16),
                  width: 250,
                  child: ShowImage(path: 'images/logo1.jpg')),
            ],
          ),
        ],
      ),
    );
  }
}
