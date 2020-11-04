import 'package:flutter/material.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/pages/map_sample.dart';
import 'package:unicorndial/unicorndial.dart';

import '../main.dart';

class FieldDetails extends StatefulWidget {
  final Field field;

  const FieldDetails({
    Key key,
    @required this.field,
  }) : super(key: key);
  @override
  _FieldDetailsState createState() => _FieldDetailsState();
}

class _FieldDetailsState extends State<FieldDetails> {
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
        Navigator.of(context).push(routeRightToLeft(MapSample()));
      },
    )));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.field.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              })
        ],
        elevation: 0,
        backgroundColor: Colors.grey[200],
        iconTheme: new IconThemeData(color: Colors.green[600]),
      ),
      body: Container(
        child: Text(widget.field.location),
      ),
      floatingActionButton: UnicornDialer(
          hasBackground: false,
          parentButtonBackground: Colors.green,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.menu),
          childButtons: childButtons),
    );
  }
}
