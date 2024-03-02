import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utility/my_constant.dart';

class DopaDebt extends StatelessWidget {
  const DopaDebt({Key? key}) : super(key: key);

 
 
  void initState() {
    // TODO: implement initState

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    // initialFile();
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: MyConstant.primary),
      ),
      body: WebView(
        initialUrl: 'https://debt.dopa.go.th/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
