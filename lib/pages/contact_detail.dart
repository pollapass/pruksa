import 'package:flutter/material.dart';
import 'package:pruksa/models/contact_model.dart';
import 'package:pruksa/utility/my_constant.dart';

class ContactDetail extends StatefulWidget {
  final ContactModel contact;
  const ContactDetail({Key? key, required this.contact}) : super(key: key);

  @override
  State<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  ContactModel? contact;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contact = widget.contact;
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
              'เรื่อง :${contact!.contact_title} วันที่ ${contact!.contact_insert}',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                  '${MyConstant.domain}/images/contact/${contact!.contact_cover}'),
            ),
           
            SizedBox(
              height: 30,
            ),
            Text(
              'รายละเอียด :${contact!.contact_detail}',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
