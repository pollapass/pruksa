import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class websitamp extends StatefulWidget {
  const websitamp({Key? key}) : super(key: key);

  @override
  State<websitamp> createState() => _websitampState();
}

class _websitampState extends State<websitamp> {
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
        initialUrl: 'https://www.banluang.org/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
  }
