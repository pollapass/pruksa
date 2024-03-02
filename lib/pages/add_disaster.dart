import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';
import '../utility/my_dialog.dart';
import '../wigets/show_image.dart';
import '../wigets/show_progress.dart';

class AddDisaster extends StatefulWidget {
  const AddDisaster({Key? key}) : super(key: key);

  @override
  State<AddDisaster> createState() => _AddDisasterState();
}

class _AddDisasterState extends State<AddDisaster> {
  final formKey = GlobalKey<FormState>();
  List groupList = [];
  String avatar = '';
  File? file;
  double? lat, lng;
  String? selecteValue;
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
        title: Text('แจ้งข้อมุลสาธารณภัย'),
        backgroundColor: Colors.pinkAccent,
        //centerTitle: true,
        actions: [
          Row(
            children: [Icon(Icons.add_box), Text('เพิ่มข้อมูล')],
          )
        ],
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              ShowTitle(
                  title: 'การแจ้งข้อมูลที่เป็นเท็จเป็นความผิดต่อเจ้าพนักงาน'),
              SizedBox(
                height: 10,
              ),
              BuildPlace(),
              SizedBox(
                height: 20,
              ),
              Builddetail(),
              ShowTitle(title: 'กรุณากรอกรูปภาพความเสียหาย'),
              SizedBox(
                height: 20,
              ),
              buildAvatar(size),
              SizedBox(
                height: 10,
              ),
              ShowTitle(title: 'แผนที่จุดเสี่ยง'),
              buildMap(),
              buildbutton(),
            ],
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

    print('## สถานที่ = $place ,รายละเอียด = $detail');

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
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/savedispic.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'dis$i.jpg';
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
        );
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
        '${MyConstant.domain}/dopa/api/insertinformdis.php?isAdd=true&name=$name&lastname=$lastname&cid=$cid&phone=$phone&place=$place&image=$avatar&lat=$lat&lng=$lng&detail=$detail';
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
            return 'กรุณากรอกข้อมูลสถานทีเกิดภัย';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกข้อมูลสถานทีเกิดภัย',
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
            return 'กรุณากรอกรายละเอียดความเสียหาย เช่น เสียหายไปกี่ไร่';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกรายละเอียดความเสียหาย เช่น เสียหายไปกี่ไร่',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
