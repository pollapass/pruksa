import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/my_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addforrest extends StatefulWidget {
  const addforrest({Key? key}) : super(key: key);

  @override
  State<addforrest> createState() => _addforrestState();
}

class _addforrestState extends State<addforrest> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cidController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('ข้อมูลคนหาของป่า')),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    validatefunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณาชื่อนามสกุลด้วยค่ะด้วยค่ะ';
                      } else {
                        return null;
                      }
                    },
                    controller: nameController,
                    hintText: 'ชื่อ-นามสกุล',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    validatefunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณากรอกเบอร์โทรศัพท์ด้วยค่ะ';
                      } else {
                        return null;
                      }
                    },
                    //keyboardType: TextInputType.number,
                    controller: phoneController,
                    hintText: 'เบอร์โทรศัพท์',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    validatefunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณากรอกบ้านเลขที่ด้วยค่ะ';
                      } else {
                        return null;
                      }
                    },
                    //keyboardType: TextInputType.number,
                    controller: addressController,
                    hintText: 'บ้านเลขที่ตามบัตรประชาชน',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    controller: cidController,
                    hintText: 'เลขบัตรประจำตัวประชาชน',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // checkAuthen(user: user, password: password);
                        // InsertData();
                      }
                    },
                    icon: Icon(Icons.save), //icon data for elevated button
                    label: Text("เพิ่มข้อมูล"), //label text
                    style: ElevatedButton.styleFrom(primary: MyConstant.primary
                        //elevated btton background color
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> InsertData() async {
    String name = nameController.text;
    String cid = cidController.text;
    String address = addressController.text;
    String phone = phoneController.text;

    print('## สถานที่ = $name ,cid = $cid');

    if (name == null || cid == null || address == null) {
      // No Avatar
      MyDialog().normalDialog(
          context, 'กรุณากรองข้อมูลให้ครบ', 'ต้องประเมินให้ครบค่ะ');
    } else {
      //      // Have Avatar
      SharedPreferences preference = await SharedPreferences.getInstance();

      String moopart = preference.getString('moopart')!;
      String addressid = preference.getString('addressid')!;
      String userkey = preference.getString('id')!;
      String apiInsertActReport =
          '${MyConstant.domain}/dopa/api/insertforrest.php?isAdd=true&userkey=$userkey&&name=$name&cid=$cid&address=$address&addressid=$addressid&phone=$phone&moopart=$moopart';
      await Dio().get(apiInsertActReport).then((value) {
        if (value.toString() == 'true') {
          Navigator.pop(context);
        } else {
          MyDialog()
              .normalDialog(context, 'ไม่สามารถเพิ่มได้!!!', 'กรุณาลองใหม่ค่ะ');
        }
      });
    }
  }
}
