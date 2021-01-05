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
          GestureDetector(
            child: Container(
              width: 120,
              height: 100,
              decoration: new BoxDecoration(
                  border: Border.all(color: Colors.grey[300], width: 3),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/dwight.jpg'),
                  )),
            ),
            onTap: () {
              Navigator.of(context).push(routeRightToLeft(UserProfile()));
            },
          ),
          Center(
            widthFactor: 1.1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    'hoşgeldin'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                Container(
                  width: 125,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    'Dwight Schrute'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.3,
                        color: Colors.white,
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
