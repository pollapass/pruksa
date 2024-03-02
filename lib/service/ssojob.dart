import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SsojobService extends StatefulWidget {
  const SsojobService({Key? key}) : super(key: key);

  @override
  State<SsojobService> createState() => _SsojobServiceState();
}

class _SsojobServiceState extends State<SsojobService> {
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
        initialUrl: 'https://www.sso.go.th/wpr/main/login',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
