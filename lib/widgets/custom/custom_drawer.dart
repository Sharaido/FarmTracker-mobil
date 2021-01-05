import 'package:flutter/material.dart';
import 'package:flutter_app/pages/expensepage.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/my_fields.dart';
import 'package:flutter_app/pages/user_profile.dart';
import 'package:flutter_app/widgets/overriden_default_widgets/my_drawer.dart';

import '../../main.dart';
import 'custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer(this.selected);
  final String selected;
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          CustomDrawerHeader(),
          Padding(padding: EdgeInsets.only(top: 10)),
          _createDrawerItem(
              icon: Icons.home,
              text: 'ANASAYFA',
              onTap: () {
                Navigator.of(context).push(routeRightToLeft(HomePage(
                  title: 'Anasayfa',
                )));
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.grass,
              text: 'TARLALARIM',
              onTap: () async {
                var jwt = await storage.read(key: "token");
                Navigator.of(context)
                    .push(routeRightToLeft(MyFields(jwt: jwt)));
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.multiline_chart,
              text: 'GELİR - GİDER',
              onTap: () {
                Navigator.of(context).push(routeRightToLeft(ExpensePage(
                  title: 'Gelir - Gider',
                )));
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.person,
              text: 'PROFIL',
              onTap: () {
                Navigator.of(context).push(routeRightToLeft(UserProfile()));
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.settings,
              text: 'AYARLAR',
              onTap: () {
                Navigator.pop(context);
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.logout,
              text: 'ÇIKIŞ YAP',
              onTap: () async {
                await storage.delete(key: "token");
                await storage.delete(key: "expire");
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (r) => false);
              },
              selected: selected),
          _createLogo(),
        ],
      ),
    );
  }
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap, String selected}) {
  bool isSelected = text == selected;
  return ListTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(left: 20)),
        Icon(
          icon,
          size: 30,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.green : Colors.black)),
        )
      ],
    ),
    onTap: onTap,
  );
}

Widget _createLogo() {
  return Column(
    children: [
      SizedBox(
        height: 35,
      ),
      Text(
        'Farm Tracker',
        style: TextStyle(fontSize: 25, color: Colors.green),
      ),
      Text('version 0.9b'),
    ],
  );
}
