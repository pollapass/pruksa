import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/damrong_model.dart';
import 'package:pruksa/utility/my_constant.dart';

class EditDamrong extends StatefulWidget {
  final DamrongModels dammodels;
  const EditDamrong({Key? key, required this.dammodels}) : super(key: key);

  @override
  State<EditDamrong> createState() => _EditDamrongState();
}

class _EditDamrongState extends State<EditDamrong> {
  DamrongModels? dammodels;
  List groupList = [];
  String? selecteValue;
  TextEditingController titleController = TextEditingController();

  TextEditingController detailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  List<String> pathImages = [];
  List<File?> files = [];
  bool statusImage = false;
  final formKey = GlobalKey<FormState>();
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dammodels = widget.dammodels;
    // print('### image from mySQL ==>> ${productModel!.images}');
    nameController.text = dammodels!.contact_name;
    //titleController.text = Riskmodels!.inform_titel;

    detailController.text = dammodels!.contact_detail;
   
    loadActivegroupFromAPI();
  }


  Future<Null> loadActivegroupFromAPI() async {
    String apiGetActiveGroup = '${MyConstant.domain}/dopa/api/getstatus.php';
    await Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    //print(poslist);
  }

  Widget build(BuildContext context) {
    return Scaffold();
  }
}
