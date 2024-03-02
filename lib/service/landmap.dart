import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class landmapservice extends StatefulWidget {
  const landmapservice({Key? key}) : super(key: key);

  @override
  State<landmapservice> createState() => _landmapserviceState();
}

class _landmapserviceState extends State<landmapservice> {
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
        initialUrl: 'https://landsmaps.dol.go.th/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
