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

Widget detailCard(String st, int count, var no, context) {
  return Flexible(
    child: Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                //print(no);
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          title: new Text("Numaralar"),
                          content: new Text(no.toString()),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Tamam'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Text(
                    st,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.green.withOpacity(1.0)),
                  ),
                  new Text(""),
                  new Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget otherCard(String st, bool bl, DateTime dt) {
  return Flexible(
    child: Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                    st,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.green.withOpacity(1.0)),
                  ),
                  new Text(""),
                  if (bl == true)
                    new Text(
                      'SULANDI',
                      style: TextStyle(
                          fontSize: 20.0, color: Colors.blue.withOpacity(1.0)),
                    ),
                  if (bl == true) new Text(""),
                  if (bl == true)
                    new Text(
                      'Sıradaki sulama tarihi 05/12/2020',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  if (bl == false)
                    new Text(
                      'GÜBRELENMEDİ',
                      style: TextStyle(
                          fontSize: 20.0, color: Colors.red.withOpacity(1.0)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
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
        child: Column(mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                'AĞAÇ BİLGİSİ',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(1.0)),
              ),
              //Text(widget.field.location),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    detailCard("TOPLAM AĞAÇ SAYISI", 220,
                        [1, 2, 3, 6, 1, 8, 13], context),
                    detailCard("TOPLAM HASTA AĞAÇ SAYISI", 5, [3, 6, 1, 8, 13],
                        context),
                  ]),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                detailCard(
                    "BU YIL DİKİLEN AĞAÇ SAYISI", 5, [3, 6, 1, 8, 13], context),
                detailCard(
                    "BU YIL ÖLEN AĞAÇ SAYISI", 5, [3, 6, 1, 8, 13], context),
              ]),
              new Text(""),
              new Text(
                'DİĞER BİLGİLER',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(1.0)),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                otherCard("SULAMA BİLGİSİ", true, DateTime.now()),
                otherCard("GÜBRE BİLGİSİ", true, DateTime.now()),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                otherCard("İLAÇLAMA BİLGİSİ", false, DateTime.now()),
                otherCard("ÜRÜN TOPLAMA BİLGİSİ", false, DateTime.now()),
              ]),
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
