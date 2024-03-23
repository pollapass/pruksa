import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pruksa/utility/my_constant.dart';

class iconsmenu extends StatelessWidget {
    final IconData iconpath;
  final String titel;
  final VoidCallback onTap;
  const iconsmenu({Key? key,
      required this.iconpath,
      required this.titel,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.blueGrey, blurRadius: 5)],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FaIcon(
                iconpath,
                size: 60,
              ),
              Text(
                titel,
                style: MyConstant().h4Style(),
              )
            ],
          ),
        ),
      ),
    );
  }
}