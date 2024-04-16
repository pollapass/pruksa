import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:pruksa/pab/add_smiv.dart';
import 'package:pruksa/pab/addactive.dart';
import 'package:pruksa/pages/add_appointment.dart';
import 'package:pruksa/pages/add_contact.dart';
import 'package:pruksa/pages/add_damrong.dart';
import 'package:pruksa/pages/add_disaster.dart';
import 'package:pruksa/pages/add_faq.dart';
import 'package:pruksa/pages/add_informrisk.dart';
import 'package:pruksa/pages/add_news.dart';
import 'package:pruksa/pages/add_newspr.dart';
import 'package:pruksa/pages/add_redcross.dart';
import 'package:pruksa/pages/admin.dart';
import 'package:pruksa/pages/admin_register.dart';
import 'package:pruksa/pages/dashboard.dart';
import 'package:pruksa/pages/login.dart';
import 'package:pruksa/pages/register.dart';
import 'package:pruksa/sarabun/add_booksend.dart';
import 'package:pruksa/sarabun/add_paynews.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';

final Map<String, WidgetBuilder> map = {
  '/Login': (BuildContext context) => Login(),
  '/Register': (BuildContext context) => Register(),
  '/Dashboard': (BuildContext context) => Dashboard(),
  '/add_informrisk': (BuildContext context) => AddInformRisk(),
  '/add_informdis': (BuildContext context) => AddDisaster(),
  '/add_damrong': (BuildContext context) => AddDamrong(),
  '/add_contact': (BuildContext context) => AddContact(),
  '/add_redcross': (BuildContext context) => AddRedcross(),
  '/add_appoint': (BuildContext context) => AddAppointment(),
  '/add_news': (BuildContext context) => AddNews(),
  '/add_faq': (BuildContext context) => AddFaq(),
  '/add_pr': (BuildContext context) => AddNewsPr(),
  '/admin': (BuildContext context) => Admin(),
  '/add_active': (BuildContext context) => addactive(),
  '/add_booksend': (BuildContext context) => addbooksend(),
  '/add_smiv': (BuildContext context) => addsmiv(),
   '/adminregister': (BuildContext context) => adminregister(),
    '/add_paynew': (BuildContext context) => addpaynews(),
};

String? initlalRoute;

Future<Null> main() async {
  HttpOverrides.global = MyHttpOverride();
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();

  await Firebase.initializeApp().then((value) async {
    print('Fibase oK');

    // await Upgrader.clearSavedSettings();
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? type = preferences.getString('type');

    if (type == null) {
      initlalRoute = MyConstant.routeLogin;
      runApp(MyApp());
    } else {
      if (type == 'user') {
        initlalRoute = MyConstant.routeDashboard;
        runApp(MyApp());
      } else {
        initlalRoute = MyConstant.routeAdmin;
        runApp(MyApp());
      }
    }
  });

  // Only call clearSavedSettings() during testing to reset internal values.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xfff06292, MyConstant.mapMaterialColor);

    return GetMaterialApp(
      title: MyConstant.appName,
      home: UpgradeAlert(
          child: Scaffold(
        appBar: AppBar(title: Text('ตรวจสอบการอับเดทโปรแกรม')),
        body: Center(child: Text('Checking...')),
      )),
      routes: map,
      initialRoute: initlalRoute,
      theme: ThemeData(primarySwatch: materialColor, useMaterial3: false),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('th', 'TH'), // Thai
      ],
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
