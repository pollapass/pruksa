import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class MyDialog {
  final Function()? funcAction;

  MyDialog({this.funcAction});

  Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.imaginfo),
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle:
              ShowTitle(title: message, textStyle: MyConstant().h3Style()),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                // Navigator.pop(context);
                await Geolocator.openLocationSettings();
                exit(0);
              },
              child: Text('OK'))
        ],
      ),
    );
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.imgwindow),
          title: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
          subtitle:
              ShowTitle(title: message, textStyle: MyConstant().h3Style()),
        ),
        children: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
        ],
      ),
    );
  }

  Future<Null> showmemberdialog(BuildContext context, String title,
      String message, String imgmember) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: ('${MyConstant.domain}/images/member/$imgmember'),
              placeholder: (context, url) => ShowProgress(),
              errorWidget: (context, url, error) =>
                  ShowImage(path: MyConstant.imgdopa),
            ),
          ),
          title: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
          subtitle:
              ShowTitle(title: message, textStyle: MyConstant().h3Style()),
        ),
        children: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
        ],
      ),
    );
  }

  Future<Null> actionDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.imaginfo),
          title: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
          subtitle:
              ShowTitle(title: message, textStyle: MyConstant().h3Style()),
        ),
        actions: [
          TextButton(
            onPressed: funcAction,
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
