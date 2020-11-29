import 'package:flutter/material.dart';
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
              text: 'HOME',
              onTap: () {
                Navigator.of(context).push(routeRightToLeft(HomePage(
                  title: 'Home',
                )));
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.grass,
              text: 'MY FIELDS',
              onTap: () async {
                var jwt = await storage.read(key: "token");
                Navigator.of(context)
                    .push(routeRightToLeft(MyFields(jwt: jwt)));
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.message,
              text: 'MESSAGES',
              onTap: () {
                Navigator.pop(context);
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.shopping_cart,
              text: 'SHOP',
              onTap: () {
                Navigator.pop(context);
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.multiline_chart,
              text: 'INCOME - EXPANSE',
              onTap: () {
                Navigator.pop(context);
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.person,
              text: 'PROFILE',
              onTap: () {
                Navigator.of(context).push(routeRightToLeft(UserProfile()));
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.settings,
              text: 'SETTINGS',
              onTap: () {
                Navigator.pop(context);
              },
              selected: selected),
          _createDrawerItem(
              icon: Icons.logout,
              text: 'LOGOUT',
              onTap: () async {
                await storage.delete(key: "token");
                await storage.delete(key: "expire");
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (r) => false);
              },
              selected: selected),
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
          padding: EdgeInsets.only(left: 18.0),
          child: Text(text,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.green : Colors.black)),
        )
      ],
    ),
    onTap: onTap,
  );
}
