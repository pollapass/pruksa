import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pruksa/models/redcross_model.dart';
import 'package:pruksa/utility/my_constant.dart';

class redcroosdetail extends StatefulWidget {
  final RedcrossModel redcrossModel;
  const redcroosdetail({Key? key, required this.redcrossModel})
      : super(key: key);

  @override
  State<redcroosdetail> createState() => _redcroosdetailState();
}

class _redcroosdetailState extends State<redcroosdetail> {
  RedcrossModel? redcrossModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redcrossModel = widget.redcrossModel;
    // print('### image from mySQL ==>> ${newsModel!.news_key}');

    // initialFile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ข้อมูลการขอรับความช่วยเหลือ'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                Text('สถานะการแก้ไขปัญหา :${redcrossModel!.status_name}  '),
                
                Text('เลชบัตร :${redcrossModel!.cid}'),
                Text('วันที่ยื่นคำร้อง :${redcrossModel!.red_date}  '),
                Text('การขอรับสนับสนุน :${redcrossModel!.help_name}  '),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'รายละเอียด ${redcrossModel!.detail}',
                  style: GoogleFonts.prompt(),
                ),
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      '${MyConstant.domain}/images/redcross/${redcrossModel!.images}'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'รายละเอียดการแก้ไขปัญหา :${redcrossModel!.remark}  ',
                  style: GoogleFonts.prompt(),
                ),
                              ],
                            )),
          ),
        ));
  }
}
