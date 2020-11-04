import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/user_profile.dart';
import 'package:flutter_app/widgets/overriden_default_widgets/my_drawer_header.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyDrawerHeader(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            child: GestureDetector(
              child: Image(
                image: AssetImage('assets/images/user(1).png'),
                width: 90,
              ),
              onTap: () {
                Navigator.of(context).push(routeRightToLeft(UserProfile()));
              },
            ),
          ),
          Center(
            widthFactor: 1.1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    'welcome'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 13),
                  ),
                ),
                Container(
                  width: 125,
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    'Name Surname'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
