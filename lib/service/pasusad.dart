import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Pasusadservicw extends StatefulWidget {
  const Pasusadservicw({Key? key}) : super(key: key);

  @override
  State<Pasusadservicw> createState() => _PasusadservicwState();
}

class _PasusadservicwState extends State<Pasusadservicw> {
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
        initialUrl: 'http://esmartsur.net/INFORM.aspx',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
