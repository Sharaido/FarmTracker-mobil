import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/pages/field_details.dart';
import 'package:flutter_app/pages/map_sample.dart';
import 'package:flutter_app/pages/my_fields.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class FieldCard extends StatefulWidget {
  FieldCard({
    Key key,
    @required this.field,
  }) : super(key: key);

  final Farm field;
  final String image = "assets/images/vector1.jpg"; //randomImage();
  @override
  _FieldCardState createState() => _FieldCardState();
}

class _FieldCardState extends State<FieldCard> {
  double height = 200;
  bool expanded = false;
  bool animFinished = false;
  String jwt;

  Future<bool> _deleteFarm(id) async {
    jwt = await storage.read(key: "token");

    final http.Response response = await http.delete(
      'http://10.0.2.2:8181/api/Farms/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
    );
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.field.id),
      onDismissed: (direction) async {
        await _deleteFarm(widget.field.id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyFields(jwt: jwt),
          ),
        );
      },
      confirmDismiss: (DismissDirection direction) async {
        final bool res = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content:
                  const Text("Are you sure you wish to delete this field?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE")),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL",
                      style: TextStyle(fontFamily: 'RobotoMono')),
                ),
              ],
            );
          },
        );
        return res;
      },
      background: _dismissibleBackground(true),
      secondaryBackground: _dismissibleBackground(false),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 0.3, color: Colors.grey)),
        elevation: 7, //8
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(routeRightToLeft(
                            FieldDetails(field: widget.field)));
                      },
                      child: Image(
                        image: AssetImage(widget.image),
                        fit: BoxFit.fitWidth,
                        width: 400,
                        height: 150,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    onEnd: () {
                      setState(() {
                        if (expanded) {
                          animFinished = true;
                        }
                      });
                    },
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    duration: Duration(milliseconds: 100),
                    height: expanded ? 130 : 50,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                enableFeedback: true,
                                alignment: Alignment.centerLeft,
                                icon: Icon(Icons.map),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(routeRightToLeft(MapSample()));
                                }),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: Text(
                                  widget.field.name.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            IconButton(
                                splashColor: Colors.green,
                                enableFeedback: true,
                                alignment: Alignment.centerRight,
                                icon: Icon(expanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down),
                                onPressed: () {
                                  setState(() {
                                    expanded = !expanded;
                                    if (animFinished) {
                                      animFinished = false;
                                    }
                                  });
                                }),
                          ],
                        ),
                        if (animFinished)
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _createInfo(
                                        icon: Icons.location_on,
                                        text: widget.field.createdBy),
                                    _createInfo(
                                        icon: Icons.crop_square,
                                        text:
                                            "${widget.field.createdBy.toString()} m² of land"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5)),
                                        Text('#',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 13.0),
                                          child: Text("${widget.field.id}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        else if (!expanded)
                          Container()
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

_dismissibleBackground(bool left) {
  return Container(
    color: Colors.red[400],
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (left)
            Icon(
              Icons.delete,
              color: Colors.white70,
            ),
          Spacer(),
          if (!left)
            Icon(
              Icons.delete,
              color: Colors.white70,
            ),
        ],
      ),
    ),
  );
}

String randomImage() {
  var rng = new Random();
  int num = rng.nextInt(3) + 1;
  return 'assets/images/field$num.jpg';
}

Widget _createInfo({IconData icon, String text}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Icon(
        icon,
        size: 20,
      ),
      Container(
          padding: EdgeInsets.only(left: 8),
          width: 340,
          child: Text(text,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  color: Colors.black)))
    ],
  );
}
