import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/pages/map_sample.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'newEntity.dart';

class FieldDetails extends StatefulWidget {
  final Property property;
  const FieldDetails({
    Key key,
    @required this.property,
  }) : super(key: key);
  @override
  _FieldDetailsState createState() => _FieldDetailsState();
}

String st = "";
Widget noButton(st) {
  return MaterialButton(
    padding: EdgeInsets.zero,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    color: Colors.blue,
    shape: CircleBorder(),
    onPressed: () {},
    child: Padding(
      padding: EdgeInsets.zero,
      child: Text(
        st,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}

Widget detailCard(String st, int count, var no, context) {
  return Flexible(
    child: Container(
      height: 110,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                            title: new Text(
                              st.toString().replaceAll('SAYISI', 'NUMARALARI'),
                            ),
                            content: Container(
                              width: MediaQuery.of(context).size.width * .0,
                              color: Colors.grey[200],
                              child: GridView.count(
                                childAspectRatio: 1,
                                crossAxisCount: (no.length / 20).toInt() + 5,
                                children: List.generate(no.length, (index) {
                                  return noButton(no[index].toString());
                                }),
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ekle'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => newEntity()),
                                  );
                                },
                              ),
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
    ),
  );
}

class _FieldDetailsState extends State<FieldDetails> {
  bool checkedValue = false;
  Widget chckbx(txt) {
    return CheckboxListTile(
      title: Text(txt),
      value: checkedValue,
      onChanged: (newValue) {
        setState(() {
          checkedValue = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Widget datepck() {
    return DateTimeField(
      format: DateFormat("yyyy-MM-dd"),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            helpText: 'Time',
            fieldHintText: 'Time',
            confirmText: 'Tamam',
            cancelText: 'İptal',
            fieldLabelText: 'Tarih giriniz.',
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
    );
  }

  Widget otherCard(String st, bool bl, DateTime dt, context) {
    return Flexible(
      child: Container(
        height: 130,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                        title: new Text(st.toString()),
                        content: Column(
                          children: [
                            if (1 == 1 && st.contains("SU")) chckbx("SULANDI"),
                            if (1 == 1 && st.contains("SU"))
                              Text(
                                "\n Sıradaki Sulama tarihi:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.blue.withOpacity(1.0)),
                              ),
                            if (1 == 1 && st.contains("SU")) datepck(),
                            if (1 == 1 && st.contains("GÜBRE"))
                              chckbx("GÜBRELENDİ"),
                            if (1 == 1 && st.contains("GÜBRE"))
                              Text(
                                "\n Sıradaki Gübreleme tarihi:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.blue.withOpacity(1.0)),
                              ),
                            if (1 == 1 && st.contains("GÜBRE")) datepck(),
                            if (1 == 1 && st.contains("İLAÇ"))
                              chckbx("İLAÇLANDI"),
                            if (1 == 1 && st.contains("İLAÇ"))
                              Text(
                                "\n Sıradaki İlaçlama tarihi:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.blue.withOpacity(1.0)),
                              ),
                            if (1 == 1 && st.contains("İLAÇ")) datepck(),
                            if (1 == 1 && st.contains("TOPLA"))
                              chckbx("TOPLANDI"),
                            if (1 == 1 && st.contains("TOPLA"))
                              Text(
                                "\n Sıradaki Ürün toplama tarihi:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.blue.withOpacity(1.0)),
                              ),
                            if (1 == 1 && st.contains("TOPLA")) datepck(),
                          ],
                        ),
                      ),
                    );
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
                      if (bl == true && st.contains("SU"))
                        new Text(
                          'SULANDI',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue.withOpacity(1.0)),
                        ),
                      if (bl == true && st.contains("SU")) new Text(""),
                      if (bl == true && st.contains("SU"))
                        new Text(
                          'Sıradaki sulama tarihi 05/12/2020',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      if (bl == false && st.contains("SU"))
                        new Text(
                          'SULANMADI',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.withOpacity(1.0)),
                        )
                      else if (bl == true && st.contains("GÜBRE"))
                        new Text(
                          'GÜBRELENDİ',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue.withOpacity(1.0)),
                        ),
                      if (bl == true && st.contains("GÜBRE")) new Text(""),
                      if (bl == true && st.contains("GÜBRE"))
                        new Text(
                          'Sıradaki gübreleme tarihi 05/12/2020',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      if (bl == false && st.contains("GÜBRE"))
                        new Text(
                          'GÜBRELENMEDİ',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.withOpacity(1.0)),
                        )
                      else if (bl == true && st.contains("İLAÇ"))
                        new Text(
                          'İLAÇLANDI',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue.withOpacity(1.0)),
                        ),
                      if (bl == true && st.contains("İLAÇ")) new Text(""),
                      if (bl == true && st.contains("İLAÇ"))
                        new Text(
                          'Sıradaki ilaçlama tarihi 05/12/2020',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      if (bl == false && st.contains("İLAÇ"))
                        new Text(
                          'İLAÇLANMADI',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.withOpacity(1.0)),
                        )
                      else if (bl == true && st.contains("TOPLA"))
                        new Text(
                          'TOPLANDI',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue.withOpacity(1.0)),
                        ),
                      if (bl == true && st.contains("TOPLA")) new Text(""),
                      if (bl == true && st.contains("TOPLA"))
                        new Text(
                          'Sıradaki toplama tarihi 05/12/2020',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      if (bl == false && st.contains("TOPLA"))
                        new Text(
                          'TOPLANMADI',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.withOpacity(1.0)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => newEntity()),
        );
      },
    )));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.property.name.toUpperCase(),
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                //Navigator.popUntil(context, ModalRoute.withName('/'));
                var jwt = await storage.read(key: "token");

                final http.Response response = await http.delete(
                  '$BASE_URL/api/Farms/Properties/${widget.property.id}',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer $jwt',
                  },
                );
                if (response.statusCode != 200) return;
                print(response.request);
                Navigator.pop(context);
              })
        ],
        elevation: 0,
        backgroundColor: Colors.grey[200],
        iconTheme: new IconThemeData(color: Colors.green[600]),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(mainAxisSize: MainAxisSize.max,
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
                    detailCard(
                        "TOPLAM AĞAÇ SAYISI",
                        220,
                        [
                          1,
                          2,
                          3,
                          4,
                          5,
                          6,
                          7,
                          8,
                          9,
                          10,
                          11,
                          12,
                          13,
                          14,
                          15,
                          16,
                          17,
                          18,
                          19,
                          20
                        ],
                        context),
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
                otherCard("SULAMA BİLGİSİ", true, DateTime.now(), context),
                otherCard("GÜBRE BİLGİSİ", true, DateTime.now(), context),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                otherCard("İLAÇLAMA BİLGİSİ", false, DateTime.now(), context),
                otherCard(
                    "ÜRÜN TOPLAMA BİLGİSİ", false, DateTime.now(), context),
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
