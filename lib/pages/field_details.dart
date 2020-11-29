import 'package:flutter/material.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/pages/map_sample.dart';
import 'package:unicorndial/unicorndial.dart';

import '../main.dart';
import 'newEntity.dart';

class FieldDetails extends StatefulWidget {
  final Farm field;
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => newEntity()),
        );
      },
    )));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          widget.field.name.toUpperCase(),
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700),
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
        color: Colors.grey[200],
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                'AĞAÇ BİLGİSİ',
                style: TextStyle(
                    fontSize: 18.0, color: Colors.black.withOpacity(1.0)),
              ),
              //Text(widget.field.location),
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.amber,
                      width: 10,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print('testing');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Text(
                              'TOPLAM AĞAÇ SAYISI',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green.withOpacity(1.0)),
                            ),
                            new Text(
                              '220',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.amber,
                      width: 10,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print('testing');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Text(
                              'TOPLAM HASTA AĞAÇ SAYISI',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green.withOpacity(1.0)),
                            ),
                            new Text(
                              '5',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.amber,
                      width: 10,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print('testing');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Text(
                              'BU YIL DİKİLEN AĞAÇ SAYISI',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green.withOpacity(1.0)),
                            ),
                            new Text(
                              '12',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Text(
                'DİĞER BİLGİLER',
                style: TextStyle(
                    fontSize: 18.0, color: Colors.black.withOpacity(1.0)),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.amber,
                      width: 10,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print('testing');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Text(
                              'SULAMA BİLGİSİ',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green.withOpacity(1.0)),
                            ),
                            new Text(
                              'SULANDI',
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.blue),
                            ),
                            new Text(
                              'Sıradaki sulama tarihi 05/12/2020',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.amber,
                      width: 10,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print('testing');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Text(
                              'GÜBRELEME BİLGİSİ',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green.withOpacity(1.0)),
                            ),
                            new Text(
                              'GÜBRELENMEDİ',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.red.withOpacity(1.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.amber,
                      width: 10,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print('testing');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Text(
                              'İLAÇLAMA BİLGİSİ',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green.withOpacity(1.0)),
                            ),
                            new Text(
                              'İLAÇLANDI',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blue.withOpacity(1.0)),
                            ),
                            new Text(
                              'Sıradaki ilaçlama tarihi 05/12/2020',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
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
