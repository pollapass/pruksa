import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pruksa/models/news_model.dart';
import 'package:pruksa/utility/my_constant.dart';

class NewsDetail extends StatefulWidget {
  final NewsModel newsModel;
  const NewsDetail({Key? key, required this.newsModel}) : super(key: key);

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  NewsModel? newsModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsModel = widget.newsModel;
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เรื่อง ${newsModel!.news_name_th}',
                style: GoogleFonts.prompt(textStyle:TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold))  , 
              ),
              SizedBox(
                height: 8,
              ),
              Text('โดย  ${newsModel!.dep_name} '),
                SizedBox(
                height: 8,
              ),
              Text(
                'วันที่ :${newsModel!.news_public}',
                style: TextStyle(color: Colors.black26),
              ),
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                    '${MyConstant.domain}/images/news/${newsModel!.news_cover}'),
              ),
              SizedBox(
                height: 30,
              ),
              Text('รายละเอียด ${newsModel!.news_description_th}',style: GoogleFonts.prompt(),),
            ],
          ),
        ),
      ),
    );
  }
}
