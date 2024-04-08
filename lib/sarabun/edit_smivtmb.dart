import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/smiv_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_titel.dart';

class editsmivtmb extends StatefulWidget {
  final smivmodel smivModel;
  const editsmivtmb({Key? key, required this.smivModel}) : super(key: key);

  @override
  State<editsmivtmb> createState() => _editsmivtmbState();
}

class _editsmivtmbState extends State<editsmivtmb> {
  smivmodel? smivModel;
  String? feel;
  String? sleep;
  String? fear;
  String? walk;
  String? speak;
  String? key;
  String? oas;
  String? confirm;
  String _radioVal = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController cidController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<File?> files = [];
  bool statusImage = false; // false => Not Change Image
  List<String> pathImages = [];
  File? file;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    smivModel = widget.smivModel;
    //print('### image from mySQL ==>> ${activeModel!.act_key}');
    nameController.text = smivModel!.sm_name;
    cidController.text = smivModel!.cid!;
    addressController.text = smivModel!.address;
    phoneController.text = smivModel!.mobile;
    sleep = smivModel!.sleep; // สมมุติมีค่า  = 0
    walk = smivModel!.warlk;
    speak = smivModel!.speak;
    feel = smivModel!.feel;
    fear = smivModel!.fear;
    key = smivModel!.sm_key;
    oas = smivModel!.oas;
    confirm = smivModel!.confirm;
    // สมมุติมีค่า  = 0
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล SMIV'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: Card(
              color: Colors.white70,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Buildname(),
                  SizedBox(
                    height: 10,
                  ),
                  Buildcid(),
                  SizedBox(
                    height: 10,
                  ),
                  Builphone(),
                  SizedBox(
                    height: 10,
                  ),
                  Buildaddress(),
                  SizedBox(
                    height: 20,
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
                  buildTitle1(' OAS แบบประเมินพฤติกรรมก้าวร้วรุนแรง'),
                  Buildoas(size),
                  buildTitle1('ส่งต่อโรงพยาบาล'),
                  Buildconfirm(size),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossFadeState,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            processEdit();
                          },
                          child: Text(
                            'อับเดทข้อมูล',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: MyConstant().mygreenbutton(),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        ElevatedButton(
                          onPressed: () {
                            _dialogBuilder(context);
                          },
                          child: Text(
                            'ลบข้อมูล',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: MyConstant().myredbutton(),
                        ),
                      ],
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

  Row Buildconfirm(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: 'N',
            groupValue: confirm,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                confirm = value as String?;
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
            value: 'Y',
            groupValue: confirm,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                confirm = value as String?;
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

  Column Buildoas(double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '1',
            groupValue: oas,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                oas = value as String?;
              });
            },
            title: ShowTitle(
              title: ' กึ่งเร่งด่วน',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '2',
            groupValue: oas,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                oas = value as String?;
              });
            },
            title: ShowTitle(
              title: 'เร่งด่วน',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '3',
            groupValue: oas,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                oas = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ฉุกเฉิน',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบข้อมูล'),
          content: const Text(
            'หากกดปุ่มยืนยันแล้วข้อมูลจะถูกลบจากฐานข้อมูล ไม่สามารถกู้ข้อมูลได้',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยืนยัน'),
              onPressed: () {
                processdel();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> processdel() async {
    MyDialog().showProgressDialog(context);

    String key = smivModel!.sm_key;
    print(' id - $key');

    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/del_smiv.php?isDelete=true&id=$key';
    await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    Navigator.pop(context);
  }

  Future<Null> processEdit() async {
    if (oas == null || confirm == null) {
      // No Avatar
      MyDialog().normalDialog(context, 'กรอกข้อมูลไม่ครบ?',
          'กรุณากรอกข้อมูล OAS และยืนยันส่งต่อโรงพยาบาลด้วยค่ะ');
    } else {
      MyDialog().showProgressDialog(context);
      String name = nameController.text;
      String cid = cidController.text;
      String address = addressController.text;
      String phone = phoneController.text;
      print('key is $key');
      String apiEditProduct =
          '${MyConstant.domain}/dopa/api/edit_smivtmb.php?isUpdate=true&feel=$feel&name=$name&cid=$cid&sleep=$sleep&fear=$fear&walk=$walk&address=$address&phone=$phone&speak=$speak&oas=$oas&confirm=$confirm&smkey=$key';
      await Dio().get(apiEditProduct).then((value) {
        if (value.toString() == 'true') {
          print('value is Success');
          //  sendnotitomember(cid);\

          Navigator.pop(context);

          Navigator.pop(context);
        } else {
          MyDialog()
              .normalDialog(context, 'ไม่สามารถอับเดทได้!!!', 'กรุณาลองใหม่ค่ะ');
        }
      });
    }
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
            activeColor: Colors.blue,
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
            activeColor: Colors.blue,
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

  Container buildTitle1(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style(),
      ),
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
            activeColor: Colors.blue,
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
            activeColor: Colors.blue,
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

  Row buildRadiosleep(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.4,
          child: RadioListTile(
            value: '0',
            groupValue: sleep,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                sleep = value as String?;
                _radioVal = 'ไม่ใช';
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
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                sleep = value as String?;
                _radioVal = 'ใช่';
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
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                walk = value as String?;
                _radioVal = 'ไม่ใช';
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
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                walk = value as String?;
                _radioVal = 'ใช่';
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
            activeColor: Colors.blue,
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
            activeColor: Colors.blue,
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

  Container Buildname() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อเรื่อง';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'ชื่อ-นามสกุล',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container Builphone() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: phoneController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกเบอร์โทร';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'เบอร์โทร',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container Buildcid() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: cidController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกเลขบัตรประจำตัวประชาชน';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'เลขบัตรประจำตัวประชาชน',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container Buildaddress() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: addressController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกเลขที่บ้านตามบัตรประชาชน';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'บ้านเลขที่บ้านตามบัตรประชาชน',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
