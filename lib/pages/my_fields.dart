import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/pages/add_field.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';
import 'package:flutter_app/widgets/fieldcart.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class MyFields extends StatefulWidget {
  final String jwt;

  MyFields({Key key, @required this.jwt}) : super(key: key);

  @override
  _MyFieldsState createState() => _MyFieldsState();
}

class _MyFieldsState extends State<MyFields> {
  Future<List<Farm>> get _farms async {
    if (__farms != null) return __farms;
    final response =
        await http.get('http://10.0.2.2:8181/api/Farms/', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.jwt}',
    });
    return parseFarms(response.body);
  }

  Future<List<Farm>> __farms;

  set _farms(Future<List<Farm>> farms) {
    __farms = farms;
  }

  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<Farm> parseFarms(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Farm>((json) => Farm.fromJson(json)).toList();
  }

  Future<Null> _getFarms() async {
    await new Future.delayed(new Duration(seconds: 0));
    setState(() {
      _farms = _farms;
    });
    return null;
  }

  _onAddField(context) {
    _farms = Future.value(null);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              elevation: 10,
              contentPadding: EdgeInsets.all(0),
              content: new NewFieldModal(widget.jwt));
        });
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "search",
      backgroundColor: Colors.green,
      mini: true,
      child: Icon(Icons.search),
      onPressed: () {},
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "add",
      backgroundColor: Colors.green,
      mini: true,
      child: Icon(Icons.add),
      onPressed: () {
        _onAddField(context);
      },
    )));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My fields'.toUpperCase(),
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[200],
        iconTheme: new IconThemeData(color: Colors.green[600]),
      ),
      body: FutureBuilder(
        future: _farms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            return RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: _getFarms,
              child: Container(
                color: Colors.grey[200],
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 70, top: 10),
                  cacheExtent: 100,
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12, 3, 12, 5),
                      child: FieldCard(field: snapshot.data[index]),
                    );
                  },
                ),
              ),
            );
          }
          return RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: _getFarms,
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'No Farms',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      drawer: CustomDrawer('MY FIELDS'),
      floatingActionButton: UnicornDialer(
          hasBackground: false,
          parentButtonBackground: Colors.green,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.menu),
          childButtons: childButtons),
    );
  }
}
