import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pruksa/models/noti_model.dart';
import 'package:pruksa/models/risk_model.dart';
import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Appservice {
  // depency คือตัวที่ใช้เรียก filed
  AppController appController = Get.put(AppController());

  Future<void> processnoti({required bool fromadmin}) async {
    //update token
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      print('object##=>$event');
      if (event == null) {
        //singout status

        await FirebaseAuth.instance.signInAnonymously().then((value) {
          processfindtoken(fromadmin: fromadmin);
        });
      } else {
        //singin status
        processfindtoken(fromadmin: fromadmin);
      }
    });
    FirebaseMessaging.onMessage.listen((event) {
      Get.snackbar(event.notification!.title!, event.notification!.body!);
      savenoti(
          title: event.notification!.title!,
          message: event.notification!.body!);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Get.snackbar(event.notification!.title!, event.notification!.body!);
      savenoti(
          title: event.notification!.title!,
          message: event.notification!.body!);
    });
  }

  Future<void> processfindtoken({required bool fromadmin}) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print('token is $token');

    if (fromadmin) {
      //from admin

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userkey = preferences.getString('id');
      String apiInsertUser =
          '${MyConstant.domain}/dopa/api/updatetoken.php?isAdd=true&token=$token&key=$userkey';

      await Dio()
          .get(apiInsertUser)
          .then((value) => print('Updatetokensuccess'));
    } else {
      //from user
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? cid = preferences.getString('cid');
      String apiInsertUser =
          '${MyConstant.domain}/dopa/api/updatemembertoken.php?isAdd=true&token=$token&key=$cid';

      await Dio()
          .get(apiInsertUser)
          .then((value) => print('Updatetoken user success'));
    }
  }

  Future<void> processalladmin() async {
    String apigetmemberlist =
        '${MyConstant.domain}/dopa/api/getalluser.php?isAdd=true';

    await Dio().get(apigetmemberlist).then((value) {
      if (appController.usermodels.isNotEmpty) {
        appController.usermodels.clear();
        appController.chooseUserModels.clear();
      }

      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        appController.usermodels.add(userModel);
        appController.chooseUserModels.add(true);
      }
    });
  }

  Future<Null> processnotitomember(
      {required String token,
      required String title,
      required String message}) async {
    String urlapi =
        '${MyConstant.domain}/dopa/api/apinoti.php?isAdd=true&title=$title&body=$message&token=$token';

    await Dio().get(urlapi).then((value) => print('Send Noti Ok'));
  }

  Future<void> processChecknoti() async {
    var result = await GetStorage().read('null');
    print('## result is $result');
  }

  Future<void> savenoti(
      {required String title, required String message}) async {
    var notis = <NotiMode>[];
    var result = await GetStorage().read('noti');
    if (result != null) {
      notis.addAll(result);
    }
  }

  Future<void> gotodirection({required String lat, required String lng}) async {
    String url = 'https://www.google.co.th/maps/search/?api&query=$lat,$lng';
    print('##map = $url');
    Uri uri = Uri.parse(url);
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Cannot open';
    }
  }

  Future<void> readalldatarisk() async {
    String urlrisk =
        'https://banluang.org//dopa/api/getriskreport.php?isAdd=true';
    await Dio().get(urlrisk).then((value) {
      if (appController.riskModels.isNotEmpty) {
        appController.riskModels.clear();
      }
      for (var element in jsonDecode(value.data)) {
        RiskModel riskmodel = RiskModel.fromMap(element);
        appController.riskModels.add(riskmodel);
      }
    });
  }
}
