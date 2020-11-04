import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: new IconThemeData(color: Colors.green),
      ),
      body: Container(
        child: Text('name'),
      ),
      drawer: CustomDrawer('PROFILE'),
    );
  }
}
