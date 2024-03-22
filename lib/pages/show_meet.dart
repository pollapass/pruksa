import 'package:flutter/material.dart';


class showmeeting extends StatefulWidget {
  const showmeeting({Key? key}) : super(key: key);

  @override
  State<showmeeting> createState() => _showmeetingState();
}

class _showmeetingState extends State<showmeeting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการปรุะชุม'),
      ),
        
    );
  }
}
