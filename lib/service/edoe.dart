import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Edoe extends StatefulWidget {
  const Edoe({Key? key}) : super(key: key);

  @override
  State<Edoe> createState() => _EdoeState();
}

class _EdoeState extends State<Edoe> {
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
        initialUrl: 'https://e-service.doe.go.th/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
