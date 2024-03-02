import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pruksa/models/informdis_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'dart:convert';
class DisasterDetail extends StatefulWidget {
  final InformDisModel informdis;
  const DisasterDetail({Key? key, required this.informdis}) : super(key: key);

  @override
  State<DisasterDetail> createState() => _DisasterDetailState();
}

class _DisasterDetailState extends State<DisasterDetail> {
  InformDisModel? informdis;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    informdis = widget.informdis;
    // print('### image from mySQL ==>> ${newsModel!.news_key}');

    // initialFile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: MyConstant.primary),
      ),
      body: LayoutBuilder(builder: (context, constraints) =>
         Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สถานะ :${informdis!.status_name}',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'วันที่ :${informdis!.inform_date}',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                      '${MyConstant.domain}/images/disaster/${informdis!.inform_images}'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'รายละเอียด ${informdis!.inform_detail}',
                  style: GoogleFonts.prompt(),
                ),
                                 Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            width: constraints.maxWidth * 0.6,
                            height: constraints.maxWidth * 0.6,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                 
                                   double.parse('${informdis!.lat}'),
                                  double.parse('${informdis!.lng}'),
                                
                                ),
                                zoom: 16,
                              ),
                              markers: <Marker>{
                                Marker(
                                    markerId: MarkerId('id'),
                                    position: LatLng(
                                       double.parse('${informdis!.lat}'),
                                  double.parse('${informdis!.lng}'),
                                    ),
                                    infoWindow: InfoWindow(
                                        title: 'คุณอยู่ที่นี่ ',
                                        snippet:
                                            'lat = ${informdis!.lat}, lng = ${informdis!.lng}')),
                              },
                            ),
                          ),
                        ],
                      ),
                ShowTitle(title: 'รายละเอียดการแก้ไขปัญหา'),
                Text(
                  ' ${informdis!.inform_remark}',
                  style: GoogleFonts.prompt(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
