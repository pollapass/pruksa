import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utility/my_constant.dart';

class BoraService extends StatefulWidget {
  const BoraService({Key? key}) : super(key: key);

  @override
  State<BoraService> createState() => _BoraServiceState();
}

class _BoraServiceState extends State<BoraService> {
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
        initialUrl: 'https://stat.bora.dopa.go.th/Wchecklname/#/CheckLname',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
