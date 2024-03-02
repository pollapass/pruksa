import 'package:flutter/material.dart';

class ItemService extends StatelessWidget {
  final String title, image;
  const ItemService({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    margin:  EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.white
      ,borderRadius: BorderRadius.circular(20),
       boxShadow: [
        BoxShadow(offset: Offset(0, 5)
        , spreadRadius: 5
        , blurRadius: 5)
      ]),
      child: Column(children: [
        Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withOpacity(.1)
                ),
            child: Image.asset(
              image,
              width: 40,
              height: 40,
            )),
        SizedBox(
          height: 5,
        ),
        Text(title)
      ]),
    );
  }
}
