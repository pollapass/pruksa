// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pruksa/models/icare_report_model.dart';
import 'package:pruksa/models/news_model.dart';
import 'package:pruksa/pab/active_main.dart';
import 'package:pruksa/pages/about.dart';
import 'package:pruksa/pages/adminmenu.dart';
import 'package:pruksa/pages/damrong_all.dart';
import 'package:pruksa/pages/disaster_all.dart';
import 'package:pruksa/pages/eservice.dart';
import 'package:pruksa/pages/faq_his.dart';
import 'package:pruksa/pages/inform_news.dart';
import 'package:pruksa/pages/informrisk_all.dart';
import 'package:pruksa/pages/member_list.dart';
import 'package:pruksa/pages/newpr_list.dart';
import 'package:pruksa/pages/news.dart';
import 'package:pruksa/pages/news_detail.dart';
import 'package:pruksa/pages/newspr.dart';
import 'package:pruksa/pages/profile.dart';
import 'package:pruksa/pages/test.dart';
import 'package:pruksa/sarabun/book_send_all.dart';
import 'package:pruksa/sarabun/sarabun_menu.dart';
import 'package:pruksa/sasuk/icare_amp.dart';
import 'package:pruksa/service/facebook.dart';
import 'package:pruksa/service/websitamp.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../wigets/show_singout.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  var height, width;

  String? nameuser;
  String? fullname;
  String? posname;
  String? avatar;
  bool load = true;
  bool? haveData;
  List<NewsModel> newsmodels = [];
  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Appservice().processnoti(fromadmin: true);
    Appservice().processChecknoti();
    loadvaluefromapi();
    finduser();
    // initialFile();
  }

  Future<Null> finduser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameuser = preferences.getString('name');
      fullname = preferences.getString('fullname');
      avatar = preferences.getString('user_photo');
      posname = preferences.getString('posname');
    });
  }

  Future<Null> loadvaluefromapi() async {
    if (newsmodels.length != 0) {
      newsmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getnews.php?isAdd=true';
    await Dio().get(apigetactivelist).then((value) {
      // print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          NewsModel model = NewsModel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            newsmodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: mainappbar(),
        body: SafeArea(
          child: ListView(
            children: [
              BuildTop(),
              const SizedBox(
                height: 15.0,
              ),
              Buildtitel(),
              SizedBox(
                height: 15.0,
              ),
              gridgroup(context),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'ข่าวล่าสุด',
                      style: MyConstant().h1blackStyle(),
                    )
                  ],
                ),
              ),
              BuildNews(),
            ],
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.home),
                  iconSize: 30,
                  color: Colors.grey,
                  onPressed: () {},
                ),
                label: 'หน้าหลัก',
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.newspaper),
                  iconSize: 30,
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => sarabunmenu()));
                  },
                ),
                label: 'สารบัญ',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.pink,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AdminMenu()));
                    },
                    child: FaIcon(
                      FontAwesomeIcons.windows,
                      size: 30,
                    ),
                  ),
                ),
                label: 'ระบบ',
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.wallet),
                  iconSize: 30,
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Eservice()));
                  },
                ),
                label: 'e-service',
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                    icon: const Icon(Icons.phone_enabled),
                    tooltip: 'ติดต่ออำเภอ',
                    iconSize: 30,
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MemberList()));
                    }),
                label: 'โทร',
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Stack(
            children: [
              ShowSignOut(),
              Column(
                children: [
                  UserAccountsDrawerHeader(
                      otherAccountsPictures: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.face_outlined),
                          iconSize: 36,
                          color: MyConstant.light,
                          tooltip: '',
                        ),
                      ],
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [MyConstant.light, MyConstant.dark],
                          center: Alignment(-0.8, -0.2),
                          radius: 1,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${MyConstant.domain}/dopa/resource/users/images/$avatar'),
                      ),
                      accountName:
                          Text(fullname == null ? 'Name ?' : '$fullname '),
                      accountEmail:
                          Text(posname == null ? 'Type ?' : ' $posname ')),

                  // ShowMenu(),
                  showprofile(),
                  MenuAbout(),
                  websitmenu(),
                  facebookmenu(),

                  // ShowProduct()
                ],
              ),
            ],
          ),
        ));
  }

  ListTile MenuAbout() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => About()),
          );
        });
      },
      leading: Icon(Icons.ac_unit_outlined),
      title: ShowTitle(title: 'เกี่ยวกับโปรแกรม'),
      subtitle: ShowTitle(title: 'แสดงรายละเอียดเกี่ยวกับโปรแกรม'),
    );
  }

  ListTile showprofile() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => profile()),
          );
        });
      },
      leading: FaIcon(FontAwesomeIcons.user),
      title: ShowTitle(title: 'Profile'),
      subtitle: ShowTitle(title: 'แก้ไขข้อมูลส่วนตัว'),
    );
  }

  ListTile test() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => test()),
          );
        });
      },
      leading: FaIcon(FontAwesomeIcons.user),
      title: ShowTitle(title: 'test'),
      subtitle: ShowTitle(title: 'ทดสอบ'),
    );
  }

  ListTile facebookmenu() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => facebook()),
          );
        });
      },
      leading: FaIcon(FontAwesomeIcons.facebook),
      title: ShowTitle(title: 'facebook'),
      subtitle: ShowTitle(title: 'fb อำเภอบ้านหลวง'),
    );
  }

  ListTile websitmenu() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => websitamp()),
          );
        });
      },
      leading: FaIcon(FontAwesomeIcons.google),
      title: ShowTitle(title: 'websit'),
      subtitle: ShowTitle(title: 'เวป อำเภอบ้านหลวง'),
    );
  }

  GridView gridgroup(BuildContext context) {
    return GridView(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3 / 2),
      children: [
        Buildrisk(context),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DisasterAll()),
            );
          },
          child: Column(
            children: [
              CircleAvatar(
                child: Image.asset('images/disaster.jpg'),
                backgroundColor: MyConstant.dark,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('ข้อมูลสาธารณภัย')
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DamrongAll()),
            );
          },
          child: Column(
            children: [
              CircleAvatar(
                child: Image.asset('images/damrong.jpg'),
                backgroundColor: MyConstant.dark,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('ร้องทุกข์ร้องเรียน')
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => activeMain()),
            );
          },
          child: Column(
            children: [
              CircleAvatar(
                child: Image.asset('images/dopa.png'),
                backgroundColor: MyConstant.dark,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('งานท้องที่')
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => booksendall()),
            );
          },
          child: Column(
            children: [
              CircleAvatar(
                child: Image.asset('images/book.png'),
                backgroundColor: MyConstant.dark,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('หนังสือเวียน')
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => icareamp()),
            );
          },
          child: Column(
            children: [
              CircleAvatar(
                child: Image.asset('images/sasuk.png'),
                backgroundColor: MyConstant.dark,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('พชอ')
            ],
          ),
        ),
      ],
    );
  }

  AppBar mainappbar() {
    return AppBar(
      // backgroundColor: Colors.transparent,
      backgroundColor: MyConstant.primary,
      elevation: 0,

      title: Text(
        'อำเภอบ้านหลวง',
        style: GoogleFonts.prompt(),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  InkWell Buildrisk(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InformRiskAll()),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            child: Image.asset('images/dopa.png'),
            backgroundColor: MyConstant.dark,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('ข้อมูลจุดเสี่ยง')
        ],
      ),
    );
  }

  Padding Buildtitel() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'หมวดหมู่',
            style: MyConstant().h1RedStyle(),
          ),
          Text(
            'ดูทั้งหมด',
            style: MyConstant().h3RedStyle(),
          )
        ],
      ),
    );
  }

  Widget BuildNews() {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: newsmodels.length,
        itemBuilder: (context, index) => Card(
              elevation: 10.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(246, 242, 247, 0.894)),
                child: ListTile(
                  onTap: () {
                    print('## You Click Edit');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetail(
                            newsModel: newsmodels[index],
                          ),
                        )).then((value) => loadvaluefromapi());
                  },
                  leading: Container(
                    width: 60,
                    height: 60,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          ('${MyConstant.domain}/images/news/${newsmodels[index].news_cover}'),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(path: MyConstant.imgdopa),
                    ),
                  ),
                  title: Text('เรื่อง:${newsmodels[index].news_name_th}'),
                  subtitle: Text('รายละเอียด'),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
                ),
              ),
            )
        //
        );
  }

  Container BuildTop() {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 20),
      decoration: BoxDecoration(
          color: MyConstant.primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'สวัสดี'),
                TextSpan(
                    text: 'คุณ $fullname ', style: MyConstant().h2WhiteStyle()),
              ])),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => profile()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        '${MyConstant.domain}/dopa/resource/users/images/$avatar'),
                    radius: 30,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
