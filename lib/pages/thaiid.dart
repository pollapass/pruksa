import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utility/my_constant.dart';

class Thaiid extends StatefulWidget {
  const Thaiid({Key? key}) : super(key: key);

  @override
  State<Thaiid> createState() => _ThaiidState();
}

class _ThaiidState extends State<Thaiid> {
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
        initialUrl:
            'https://play.google.com/store/apps/details?id=th.go.dopa.bora.dims.ddopa',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
