import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PapaService extends StatefulWidget {
  const PapaService({Key? key}) : super(key: key);

  @override
  State<PapaService> createState() => _PapaServiceState();
}

class _PapaServiceState extends State<PapaService> {
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
            'https://customer-application.pwa.co.th/register-service/add',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
