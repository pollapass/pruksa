import 'package:flutter/material.dart';
import 'package:pruksa/models/damrong_model.dart';
import 'package:pruksa/utility/my_constant.dart';


class DamrongDetail extends StatefulWidget {
  final DamrongModels damrong;
  const DamrongDetail({Key? key, required this.damrong}) : super(key: key);

  @override
  State<DamrongDetail> createState() => _DamrongDetailState();
}

class _DamrongDetailState extends State<DamrongDetail> {
  DamrongModels? damrong;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    damrong = widget.damrong;
    // print('### image from mySQL ==>> ${newsModel!.news_key}');

    // initialFile();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: MyConstant.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เรื่อง :${damrong!.contact_title} วันที่ ${damrong!.contact_insert}',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                  '${MyConstant.domain}/images/damrong/${damrong!.contact_images}'),
            ),
           
            SizedBox(
              height: 30,
            ),
            Text(
              'รายละเอียด :${damrong!.contact_detail}',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}