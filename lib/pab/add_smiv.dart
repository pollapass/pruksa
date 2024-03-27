import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/my_textfield.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addsmiv extends StatefulWidget {
  const addsmiv({Key? key}) : super(key: key);

  @override
  State<addsmiv> createState() => _addsmivState();
}

class _addsmivState extends State<addsmiv> {
  String? feel;
  String? sleep;
  String? fear;
  String? walk;
  String? speak;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cidController = TextEditingController();
    TextEditingController addressController = TextEditingController();
  TextEditingController  phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลคัดกรองผู้ป่วย'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
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
                    buildTitle1(' ไม่หลับไม่นอน'),
                    buildRadiosleep(size),
                    buildTitle1(' เดินไปเดินมา'),
                    buildRadiowalk(size),
                    buildTitle1(' พูดจาคนเดียว '),
                    buildRadiospeak(size),
                    buildTitle1('หงุดหงิดฉุนเฉียว'),
                    buildRadiofeel(size),
                    buildTitle1('เที่ยวหวาดระแวง'),
                    buildRadiofear(size),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // checkAuthen(user: user, password: password);
                          InsertData();
                        }
                      },
                      icon: Icon(Icons.save), //icon data for elevated button
                      label: Text("เพิ่มข้อมูล"), //label text
                      style:
                          ElevatedButton.styleFrom(primary: MyConstant.primary
                              //elevated btton background color
                              ),
                    ),
                  ],
                ),
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

    if (feel == null || sleep == null || fear == null || speak == null || walk == null) {
      // No Avatar
      MyDialog().normalDialog(context, 'กรุณากรองข้อมูลให้ครบ', 'ต้องประเมินให้ครบค่ะ');
    
    } else {
      //      // Have Avatar
        SharedPreferences preference = await SharedPreferences.getInstance();

    String moopart = preference.getString('moopart')!;
    String addressid = preference.getString('addressid')!;
    String userkey = preference.getString('id')!;
          String apiInsertActReport =
        '${MyConstant.domain}/dopa/api/insertsmiv.php?isAdd=true&userkey=$userkey&feel=$feel&name=$name&cid=$cid&sleep=$sleep&fear=$fear&walk=$walk&address=$address&addressid=$addressid&phone=$phone&moopart=$moopart&speak=$speak';
    await Dio().get(apiInsertActReport).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มได้!!!', 'กรุณาลองใหม่ค่ะ');
      }
    });
      }
    }


  Container buildTitle1(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }

  Row buildRadiosleep(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: sleep,
            onChanged: (value) {
              setState(() {
                sleep = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่ใ่ช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: sleep,
            onChanged: (value) {
              setState(() {
                sleep = value as String?;
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

  Row buildRadiowalk(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: walk,
            onChanged: (value) {
              setState(() {
                walk = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่ใ่ช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: walk,
            onChanged: (value) {
              setState(() {
                walk = value as String?;
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

  Row buildRadiospeak(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: speak,
            onChanged: (value) {
              setState(() {
                speak = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่ใ่ช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: speak,
            onChanged: (value) {
              setState(() {
                speak = value as String?;
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

  Row buildRadiofeel(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: feel,
            onChanged: (value) {
              setState(() {
                feel = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่ใ่ช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: feel,
            onChanged: (value) {
              setState(() {
                feel = value as String?;
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

  Row buildRadiofear(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: fear,
            onChanged: (value) {
              setState(() {
                fear = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ไม่ใ่ช่',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: fear,
            onChanged: (value) {
              setState(() {
                fear = value as String?;
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
