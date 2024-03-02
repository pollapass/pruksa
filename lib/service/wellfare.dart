import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Wellfare extends StatefulWidget {
  const Wellfare({Key? key}) : super(key: key);

  @override
  State<Wellfare> createState() => _WellfareState();
}

class _WellfareState extends State<Wellfare> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    // initialFile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: MyConstant.primary),
      ),
      body: WebView(
        initialUrl: 'https://govwelfare.cgd.go.th/welfare/check',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
