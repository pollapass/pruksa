import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appservice {
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
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Get.snackbar(event.notification!.title!, event.notification!.body!);
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
}
