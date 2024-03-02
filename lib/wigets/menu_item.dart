import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';

class MenuItem extends StatelessWidget {
  final String imagepath;
  final String titel;
  final VoidCallback onTap;

  const MenuItem(
      {Key? key,
      required this.imagepath,
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
              Image.asset(
                imagepath,
                width: 80,
                height: 80,
              ),
              Text(
                titel,
                style: MyConstant().h3Style(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
