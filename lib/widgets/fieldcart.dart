import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/pages/field_details.dart';
import 'package:flutter_app/pages/map_sample.dart';

import '../main.dart';

class FieldCard extends StatefulWidget {
  FieldCard({
    Key key,
    @required this.field,
  }) : super(key: key);

  final Field field;
  final String image = "assets/images/vector1.jpg"; //randomImage();
  @override
  _FieldCardState createState() => _FieldCardState();
}

class _FieldCardState extends State<FieldCard> {
  double height = 200;
  bool expanded = false;
  bool animFinished = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide(width: 0.3, color: Colors.grey)),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(routeRightToLeft(FieldDetails(field: widget.field)));
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
                                Navigator.of(context).push(routeRightToLeft(MapSample()));
                              }),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Text(
                                widget.field.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          IconButton(
                              splashColor: Colors.green,
                              enableFeedback: true,
                              alignment: Alignment.centerRight,
                              icon: Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
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
                                  _createInfo(icon: Icons.location_on, text: widget.field.location),
                                  _createInfo(
                                      icon: Icons.crop_square, text: "${widget.field.size.toString()} m² of land"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(left: 5)),
                                      Text('#',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 13.0),
                                        child: Text(
                                            "Total of ${widget.field.farms.length} farms and " +
                                                "${widget.field.getTotalEntity().toString()} entities",
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
    );
  }
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
              style: TextStyle(fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.w500, color: Colors.black)))
    ],
  );
}
