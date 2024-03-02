import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_titel.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeLogin, (route) => false),
                );
          },
          tileColor: MyConstant.primary,
          leading: Icon(
            Icons.exit_to_app_rounded,
            size: 30,
            color: Colors.white,
          ),
          title:  ShowTitle(
              title: 'Sing Out', textStyle: MyConstant().h2WhiteStyle()),
          subtitle: ShowTitle(
            title: 'ออกจากระบบ',
            textStyle: MyConstant().h3WhiteStyle(),
          ),
        ),
      ],
    );
  }
}
