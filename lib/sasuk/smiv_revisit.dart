import 'package:flutter/material.dart';

class smivrevisit extends StatefulWidget {
  const smivrevisit({Key? key}) : super(key: key);

  @override
  State<smivrevisit> createState() => _smivrevisitState();
}

class _smivrevisitState extends State<smivrevisit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลการเยี่ยม'),
      ),
    );
  }
}
