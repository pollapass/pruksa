import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_dialog.dart';
import '../wigets/show_image.dart';
import '../wigets/show_progress.dart';

class AddInformRisk extends StatefulWidget {
  const AddInformRisk({Key? key}) : super(key: key);

  @override
  State<AddInformRisk> createState() => _AddInformRiskState();
}

class _AddInformRiskState extends State<AddInformRisk> {
  String avatar = '';
  File? file;
  double? lat, lng;

  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');

      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ Location');
        } else {
          // Find LatLang
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ Location');
        } else {
          // Find LatLng
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      MyDialog().alertLocationService(context, 'Location Service ปิดอยู่ ?',
          'กรุณาเปิด Location Service ด้วยคะ');
    }
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('แจ้งจุดเสี่ยงแหล่งมั่วสุม'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
          child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShowTitle(
                        title: 'คำเตือน:การแจ้งเท็จเป็นความผิดต่อเจ้าพนักงาน',
                        textStyle: MyConstant().h3Style(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BuildPlace(),
                      SizedBox(
                        height: 10,
                      ),
                      BuildSubject(),
                      SizedBox(
                        height: 10,
                      ),
                      Builddetail(),
                      SizedBox(
                        height: 10,
                      ),
                      buildAvatar(size),
                      SizedBox(
                        height: 10,
                      ),
                      ShowTitle(
                        title: 'พิกัดสถานที่เสี่ยง',
                        textStyle: MyConstant().h3Style(),
                      ),
                      buildMap(),
                      SizedBox(
                        height: 10,
                      ),
                      buildbutton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  ElevatedButton buildbutton() {
    return ElevatedButton.icon(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // checkAuthen(user: user, password: password);
          uploadPictureAndInsertData();
        }
      },
      label: Text(
        "เพิ่มข้อมูล",
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.save,
        size: 24,
        color: Colors.white,
      ),

      //style: MyConstant().mydarkbutton(),
      style: ElevatedButton.styleFrom(
        primary: MyConstant.dark,
        minimumSize: Size(100, 40), //elevated btton background color
      ),
    );
  }

  Future<Null> uploadPictureAndInsertData() async {
    String place = placeController.text;
    String detail = detailController.text;
    String titel = titleController.text;

    print(
        '## สถานที่ = $place ,รายละเอียด = $detail, ชื่อผู้กระทำผิด = $titel');

    if (file == null) {
      // No Avatar
      MyDialog().normalDialog(
          context, 'ไม่ได้แนบรูปภาพ ?', 'กรุณาแนบรูปภาพแหล่งมัีวสุมด้วยค่ะ');
    } else {
      //      // Have Avatar
      print('### process Upload Avatar');
      SharedPreferences preference = await SharedPreferences.getInstance();

      String cid = preference.getString('cid')!;
      String phone = preference.getString('phone')!;
      String name = preference.getString('name')!;
      String lastname = preference.getString('lastname')!;

      print('### cid = $cid');

      print('### process Upload Avatar');
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/saveriskpic.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'risk$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameAvatar);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveAvatar, data: data).then((value) {
        avatar = '$nameAvatar';
        print('### avatar = $avatar');
        processInsertMySQL(
            name: name,
            lastname: lastname,
            phone: phone,
            cid: cid,
            place: place,
            detail: detail,
            titel: titel);
      });
    }
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? place,
      String? titel,
      String? phone,
      String? detail,
      String? lastname,
      String? cid}) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/dopa/api/insertinformrisk.php?isAdd=true&name=$name&lastname=$lastname&cid=$cid&phone=$phone&place=$place&image=$avatar&lat=$lat&lng=$lng&detail=$detail&titel=$titel';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มข้อมูลได้!!!', 'โปรดลองใหม่อีกครั่ง');
      }
    });
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Future<Null> findLatLng() async {
    print('findLatLan ==> Work');
    Position? position = await findPostion();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<Position?> findPostion() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'พิกัดสถานท่ี่เสี่ยง', snippet: 'Lat = $lat, lng = $lng'),
        ),
      ].toSet();
  Widget buildMap() => Container(
        width: double.infinity,
        height: 300,
        child: lat == null
            ? ShowProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                onMapCreated: (controller) {},
                markers: setMarker(),
              ),
      );

  Widget buildMap1() => Container(
      color: Colors.grey,
      width: double.infinity,
      height: 200,
      child: lat == null ? ShowProgress() : Text('lat = $lat lng = $lng'));

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.5,
          height: size * 0.5,
          child: file == null
              ? ShowImage(path: MyConstant.imgphoto)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  Container BuildPlace() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: placeController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูลสถานทีเสี่ยง';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกสถานที่เสี่ยง',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container Builddetail() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกรายละเอียด';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกรายละเอียดสถานที่เสี่ยง',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container BuildSubject() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: titleController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'ชื่อผู้กระทำผิดถ้ามี',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
