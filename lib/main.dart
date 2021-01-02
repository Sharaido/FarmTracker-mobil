import 'package:flutter/material.dart';
import 'package:flutter_app/pages/field_details.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:flutter_app/pages/login_page.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './pages/expensepage.dart';

import 'models/field.dart';

final storage = FlutterSecureStorage();
const String BASE_URL = "http://10.0.2.2:8181";
//const String BASE_URL = "http://192.168.0.18:8181";
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green,
          //primaryColor: Colors.green[500],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Roboto',
              bodyColor: Colors.black,
              displayColor: Colors.black)),

      // home: HomePage(
      //   title: 'Home',
      // ),
      //home: LoginPage(),
     /* home: FieldDetails(
        property: new Property(
            categoryID: 2,
            createdBy: "asd",
            id: "asd",
            name: "Tarla",
            desc: "asd",
            createdDate: "asd",
            farmID: "asd"),
      ),*/

       home: ExpensePage(
        title: 'Expenses',
       ),

      routes: {
        '/login': (context) => LoginPage(),
        '/homepage': (context) => HomePage(),
        '/expense': (context) => ExpensePage(title: 'Expenses'),
      },
    );
  }
}

Route routeRightToLeft(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route routeLeftToRight(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1, 0);
      var end = Offset(0, 0);
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route routeBottomToUp(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0, 1);
      var end = Offset(0, 0);
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route routeUpToBottom(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0, -1);
      var end = Offset(0, 0);
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
