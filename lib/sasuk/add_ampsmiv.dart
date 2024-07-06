import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/my_textfield.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class addampsmiv extends StatefulWidget {
  const addampsmiv({Key? key}) : super(key: key);

  @override
  State<addampsmiv> createState() => _addampsmivState();
}

class _addampsmivState extends State<addampsmiv> {
  String? feel;
  String? sleep;
  String? fear;
  String? walk;
  String? speak;
  String? oas;
  String? type;
  String? level;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cidController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mooController = TextEditingController();
  List typeList = [];
  List addresslist = [];
  String? selecteValue;
  String? addressValue;
  AppController appController = Get.put(AppController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // สมมุติมีค่า  = 0
    loadAddressAPI();
    loadActivegroupFromAPI();
  }

  Future<Null> loadtypeFromAPI() async {
    print('type is $type');
    String apiGetActiveGroup =
        '${MyConstant.domain}/dopa/api/getsmtypebytype.php?isAdd=true&id=$type';
    await dio.Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        typeList = item;
      });
    });
    //print(poslist);
  }

  Future<Null> loadAddressAPI() async {
    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/dopa/api/getaddress.php';
    await dio.Dio().get(apiGetProductWhereIdSeller).then((value) {
      // print('value ==> $value');
      var item = json.decode(value.data);
      setState(() {
        addresslist = item;
      });
    });
    //print(poslist);
  }

  Future<Null> loadActivegroupFromAPI() async {
    String apiGetActiveGroup = '${MyConstant.domain}/dopa/api/getsmtype.php';
    await dio.Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        typeList = item;
      });
    });
    print(typeList);
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูล Smiv อำเภอ'),
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
                    SizedBox(
                      height: 30,
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
                      hintText: 'บ้านเลขที่',
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      validatefunc: (p0) {
                        if (p0?.isEmpty ?? true) {
                          return 'กรุณากรอกข้อมูลหมู่ที่ด้วยค่ะ';
                        } else {
                          return null;
                        }
                      },
                      //keyboardType: TextInputType.number,

                      controller: mooController,
                      hintText: 'หมู่ที่',
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BuidAdress(size),
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
                    buildTitle1(' OAS แบบประเมินพฤติกรรมก้าวร้วรุนแรง'),
                    Buildoas(size),
                    buildTitle1('กลุ่มที่มีอาการทางจิต'),
                    Buildlevel(size),
                    buildTitle1('ประเภท SMI-V'),
                    buildGroup(constraints),
                    SizedBox(
                      height: 20,
                    ),
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

  Container BuidAdress(double size) {
    return Container(
      width: size * 0.7,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุตำบล'),
          value: addressValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: addresslist.map((pos) {
            return DropdownMenuItem(
                value: pos['addressid'], child: Text(pos['full_name']));
          }).toList(),
          onChanged: (value) {
            setState(() {
              loadAddressAPI();
              addressValue = value as String;
            });
          }),
    );
  }

  Widget buildGroup(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: DropdownButtonFormField(
          isExpanded: true,
          //hint: Text('กรุณาระบุประเภท'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: typeList.map((pos) {
            return DropdownMenuItem(
                value: pos['sm_type'], child: Text(pos['type_name']));
            // print(pos['active_id']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              //selecteValue = null;
              loadActivegroupFromAPI();
              selecteValue = value as String;
              //_getActiveList();
              print(selecteValue);
            });
          }),
    );
  }

  Row Buildlevel(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size * 0.3,
          child: RadioListTile(
            value: '0',
            groupValue: level,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                level = value as String?;
              });
            },
            title: ShowTitle(
              title: 'สีเขียว',
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.greenAccent,
              ),
            ),
          ),
        ),
        Container(
          width: size * 0.3,
          child: RadioListTile(
            value: '1',
            groupValue: level,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                level = value as String?;
              });
            },
            title: ShowTitle(
              title: 'สีเหลือง',
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.amber,
              ),
            ),
          ),
        ),
        Container(
          width: size * 0.3,
          child: RadioListTile(
            value: '2',
            groupValue: level,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                level = value as String?;
              });
            },
            title: ShowTitle(
              title: 'สีแดง',
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.redAccent,
              ),
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

  Future<Null> InsertData() async {
    String name = nameController.text;
    String cid = cidController.text;
    String address = addressController.text;
    String phone = phoneController.text;

    print('## สถานที่ = $name ,cid = $cid');

    if (feel == null ||
        sleep == null ||
        fear == null ||
        speak == null ||
        walk == null ||
        oas == null ||
        level == null) {
      // No Avatar
      MyDialog().normalDialog(
          context, 'กรุณากรองข้อมูลให้ครบ', 'ต้องประเมินให้ครบค่ะ');
    } else {
      //      // Have Avatar
      SharedPreferences preference = await SharedPreferences.getInstance();

      String moopart = mooController.text;

      String userkey = preference.getString('id')!;
      String apiInsertActReport =
          '${MyConstant.domain}/dopa/api/insertampsmiv.php?isAdd=true&userkey=$userkey&feel=$feel&name=$name&cid=$cid&sleep=$sleep&fear=$fear&walk=$walk&address=$address&addressid=$addressValue&phone=$phone&moopart=$moopart&speak=$speak&oas=$oas&type=$selecteValue&level=$level';
      await dio.Dio().get(apiInsertActReport).then((value) {
        if (value.toString() == 'true') {
          Get.back();
          Get.snackbar(
            "Success",
            "เพิ่มข้อมูลผูป้วยสำเร็จ",
            colorText: Colors.white,
            backgroundColor: Colors.lightGreen,
            icon: const Icon(Icons.add_alert),
            duration: Duration(seconds: 4),
          );
          for (var i = 0; i < appController.usermodels.length; i++) {
            if ((appController.usermodels[i].token!.isNotEmpty)) {
              Appservice().processnotitouser(
                  token: appController.usermodels[i].token!,
                  title: 'มีการเพิ่มผู้ป่วย SMIV',
                  message: 'กรุณาดูข้อมูล SMIV อำเภอ!!');
            }
          }
        } else {
          MyDialog()
              .normalDialog(context, 'ไม่สามารถเพิ่มได้!!!', 'กรุณาลองใหม่ค่ะ');
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
