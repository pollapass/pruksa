import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/model_user.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_titel.dart';

class editrequser extends StatefulWidget {
  final Modeluser appointModels;
  const editrequser({Key? key, required this.appointModels}) : super(key: key);

  @override
  State<editrequser> createState() => _editrequserState();
}

class _editrequserState extends State<editrequser> {
  Modeluser? appointModels;
  String? status;
  final formKey = GlobalKey<FormState>();
  void initState() {
    // TODO: implement initState
    super.initState();
    appointModels = widget.appointModels;
    status = appointModels!.user_status;

    // print('### image from mySQL ==>> ${productModel!.images}');
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('คำร้องขอเข้าสู่ระบบของเจ้าหน้าที่'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  'ข้อมูลผู้ขอใช้ระบบ',
                  style: MyConstant().h1blackStyle(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'ผู้ร้อง:${appointModels!.fullname}',
                  style: MyConstant().gh2Style(),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text('ตำแหน่ง:${appointModels!.pos_name} ',
                    style: MyConstant().gh2Style()),
                const SizedBox(
                  height: 10.0,
                ),
                Text('อนุญาติเข้าระบบ ', style: MyConstant().gh2Style()),
                const SizedBox(
                  height: 10.0,
                ),
                Buildconfirm(size),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      processEdit();
                    }
                  },
                  child: Text(
                    'อับเดทข้อมูล',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: MyConstant().mygreenbutton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      //MyDialog().showProgressDialog(context);

      String id = appointModels!.user_key;

      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/edit_requser.php?isUpdate=true&id=$id&remark=$status';
      await Dio().get(apiEditProduct).then((value) {
        if (value.toString() == 'true') {
          print('value is Success');
           Navigator.pop(context);
    
          // sendnotitomember(cid);
          MyDialog()
              .normalDialog(context, 'แจ้งเตือน', 'การอับเดทข้อมูลสำเร็จ');
        } else {
          MyDialog()
              .normalDialog(context, 'แจ้งเตือน', 'การอับเดทข้อมูลไม่สำเร็จ');
        }
      });
    }
  }

  Row Buildconfirm(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: status,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                status = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: status,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                status = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ใช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }
}
