import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PeaService extends StatefulWidget {
  const PeaService({Key? key}) : super(key: key);

  @override
  State<PeaService> createState() => _PeaServiceState();
}

class _PeaServiceState extends State<PeaService> {
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
        initialUrl: 'https://peacos.pea.co.th/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
