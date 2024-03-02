import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SmartjobService extends StatefulWidget {
  const SmartjobService({Key? key}) : super(key: key);

  @override
  State<SmartjobService> createState() => _SmartjobServiceState();
}

class _SmartjobServiceState extends State<SmartjobService> {
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
        initialUrl: 'https://smartjob.doe.go.th/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
