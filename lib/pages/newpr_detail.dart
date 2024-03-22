import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class newprdetail extends StatelessWidget {
  final String pdfurl;
  final String titel;
  const newprdetail({Key? key, required this.pdfurl, required this.titel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$titel'),
      ),
      body: const PDF(defaultPage: 0, swipeHorizontal: false, autoSpacing: true)
          .fromUrl(pdfurl),
    );
  }
}
