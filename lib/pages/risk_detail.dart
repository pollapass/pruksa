import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pruksa/models/informrisk_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_titel.dart';

class RiskDetail extends StatefulWidget {
  final InformriskModel informriskModel;
  const RiskDetail({Key? key, required this.informriskModel}) : super(key: key);

  @override
  State<RiskDetail> createState() => _RiskDetailState();
}

class _RiskDetailState extends State<RiskDetail> {
  InformriskModel? informriskModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    informriskModel = widget.informriskModel;
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
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สถานะ :${informriskModel!.status_name}',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'วันที่ :${informriskModel!.inform_date}',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                      '${MyConstant.domain}/images/informrisk/${informriskModel!.inform_images}'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'รายละเอียด ${informriskModel!.inform_detail}',
                  style: GoogleFonts.prompt(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'สถานที่',
                  style: GoogleFonts.prompt(),
                ),
                SizedBox(
                  height: 10,
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
                            double.parse('${informriskModel!.lat}'),
                            double.parse('${informriskModel!.lng}'),
                          ),
                          zoom: 16,
                        ),
                        markers: <Marker>[
                          Marker(
                              markerId: MarkerId('id'),
                              position: LatLng(
                                double.parse('${informriskModel!.lat}'),
                                double.parse('${informriskModel!.lng}'),
                              ),
                              infoWindow: InfoWindow(
                                  title: 'You Here ',
                                  snippet:
                                      'lat = ${informriskModel!.lat}, lng = ${informriskModel!.lng}')),
                        ].toSet(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ShowTitle(title: 'รายละเอียดการแก้ไขปัญหา'),
                Text(
                  ' ${informriskModel!.inform_remark}',
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
