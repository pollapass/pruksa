import 'package:flutter/material.dart';
import 'package:pruksa/models/damrong_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_titel.dart';

class DamrongDetail extends StatefulWidget {
  final DamrongModels Damrong;
  const DamrongDetail({Key? key, required this.Damrong}) : super(key: key);

  @override
  State<DamrongDetail> createState() => _DamrongDetailState();
}

class _DamrongDetailState extends State<DamrongDetail> {
  DamrongModels? Damrong;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Damrong = widget.Damrong;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เรื่อง :${Damrong!.contact_title} ',
                style: TextStyle(color: Colors.black),
              ),
              Text('วันที่แจ้ง ${Damrong!.contact_insert} '),
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                    '${MyConstant.domain}/images/damrong/${Damrong!.contact_images}'),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'รายละเอียด :${Damrong!.contact_detail}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              ShowTitle(title: 'รายละเอียดการแก้ไขปัญหา'),
              Text(
                'รายละเอียด :${Damrong!.contact_remark}',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
