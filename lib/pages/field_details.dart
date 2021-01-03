import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'newEntity.dart';

class EntityProvider extends ChangeNotifier {
  Future future;

  EntityProvider(Property property) {
    property.getAllEntities().then((value) {
      property.all = value;
      future = property.setEntitiesList().then((value) {
        notifyListeners();
      });
    });
  }

  void setFuture(Future newFuture) {
    future = newFuture;
    notifyListeners();
  }

  void updateFuture(Property property) async {
    property.getAllEntities().then((value) {
      property.all = value;
      future = property.setEntitiesList();
      notifyListeners();
    });
  }
}

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
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: MaterialButton(
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: Colors.green,
      shape: CircleBorder(),
      onPressed: () {},
      child: Text(
        st,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}

class _FieldDetailsState extends State<FieldDetails> {
  bool fertilizerValue = false;
  bool sprayValue = false;
  bool irrigationValue = false;
  bool harvestValue = false;
  TextEditingController kgController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController skgController = TextEditingController();
  TextEditingController svalueController = TextEditingController();
  Widget fertilizerCheck() {
    return Checkbox(
        value: fertilizerValue,
        onChanged: (bool value) {
          setState(() {
            fertilizerValue = value;
          });
        });
  }

  Widget sprayCheck() {
    return Checkbox(
        value: sprayValue,
        onChanged: (bool value) {
          setState(() {
            sprayValue = value;
          });
        });
  }

  Widget irrigationCheck() {
    return Checkbox(
        value: irrigationValue,
        onChanged: (bool value) {
          setState(() {
            irrigationValue = value;
          });
        });
  }

  Widget harvestCheck() {
    return Checkbox(
        value: harvestValue,
        onChanged: (bool value) {
          setState(() {
            harvestValue = value;
          });
        });
  }

  Widget detailCard(String st, int count, List<Entity> no, context) {
    return Flexible(
      child: Container(
        height: 110,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: Color.fromARGB(255, 66, 105, 47),
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
                                st
                                    .toString()
                                    .replaceAll('SAYISI', 'NUMARALARI'),
                                textAlign: TextAlign.center,
                              ),
                              content: Container(
                                width: MediaQuery.of(context).size.width * .0,
                                color: Colors.grey[200],
                                child: GridView.count(
                                  childAspectRatio: 1,
                                  crossAxisCount:
                                      6, //(no.length / 20).toInt() + 5 ibret alın
                                  children: List.generate(no.length, (index) {
                                    return noButton(no[index].fakeID);
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
                                          builder: (context) => newEntity(
                                                property: widget.property,
                                              )),
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
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      new Text(""),
                      new Text(
                        count.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
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

  Widget seasonPick() {
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

  Widget irrigationPick() {
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

  Widget fertilizerPick() {
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

  Widget sprayPick() {
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

  Widget harvestPick() {
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

  Widget productEntry() {
    return new Column(
      children: [
        new TextFormField(
          controller: kgController,
          validator: (String value) {
            if (value.isEmpty) return "Boş kalamaz";
            return null;
          },
          decoration: new InputDecoration(labelText: "KG"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
        ),
        new TextFormField(
          controller: valueController,
          validator: (String value) {
            if (value.isEmpty) return "Boş kalamaz";
            return null;
          },
          decoration: new InputDecoration(labelText: "Değeri"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
        ),
        seasonPick(),
      ],
    );
  }

  Widget seasonEntry() {
    return new Column(
      children: [
        new TextFormField(
          controller: skgController,
          validator: (String value) {
            if (value.isEmpty) return "Boş kalamaz";
            return null;
          },
          decoration: new InputDecoration(labelText: "KG"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
        ),
        new TextFormField(
          controller: svalueController,
          validator: (String value) {
            if (value.isEmpty) return "Boş kalamaz";
            return null;
          },
          decoration: new InputDecoration(labelText: "Değeri"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
        ),
        seasonPick(),
      ],
    );
  }

  Widget productCard(String st, bool bl, context, kg, value, harvestDate) {
    return Flexible(
      child: Container(
        height: 130,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: Color.fromARGB(255, 93, 67, 44),
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
                          st.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.green.withOpacity(1.0)),
                        ),
                        content: Column(
                          children: [
                            if (st.toString().contains("TOPLAM"))
                              productEntry(),
                            if (st.toString().contains("DÖNEM")) seasonEntry(),
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
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      new Text(
                        "KG: " + kg.toString(),
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      new Text(
                        "Değeri: " + value.toString(),
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      new Text(
                        "Hasat Tarihi: " + harvestDate.toString(),
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                        textAlign: TextAlign.center,
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

  Widget otherCard(String st, isBool, otherDate, context, Color color) {
    return Flexible(
      child: Container(
        height: 130,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: color,
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
                      builder: (context) => new AlertDialog(
                        title: new Text(st.toString()),
                        content: Column(
                          children: [
                            if (1 == 1 && st.contains("SU"))
                              Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    irrigationCheck(),
                                    Text("Sulandı"),
                                  ],
                                ),
                                Text(
                                  "\n Sıradaki Sulama tarihi:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blue.withOpacity(1.0)),
                                  textAlign: TextAlign.center,
                                ),
                                irrigationPick(),
                              ]),
                            if (1 == 1 && st.contains("GÜBRE"))
                              Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    fertilizerCheck(),
                                    Text("Gübrelendi"),
                                  ],
                                ),
                                Text(
                                  "\n Sıradaki Gübreleme tarihi:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blue.withOpacity(1.0)),
                                  textAlign: TextAlign.center,
                                ),
                                fertilizerPick(),
                              ]),
                            if (1 == 1 && st.contains("İLAÇ"))
                              Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    sprayCheck(),
                                    Text("İlaçlandı"),
                                  ],
                                ),
                                Text(
                                  "\n Sıradaki İlaçlama tarihi:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blue.withOpacity(1.0)),
                                  textAlign: TextAlign.center,
                                ),
                                sprayPick()
                              ]),
                            if (1 == 1 && st.contains("HASAT"))
                              Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    harvestCheck(),
                                    Text("Toplandı"),
                                  ],
                                ),
                                Text(
                                  "\n Sıradaki Ürün toplama tarihi:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blue.withOpacity(1.0)),
                                  textAlign: TextAlign.center,
                                ),
                                harvestPick()
                              ]),
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
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      new Text(""),
                      if (isBool == true && st.contains("SU"))
                        new Text(
                          'SULANDI',
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.purple[800]),
                          textAlign: TextAlign.center,
                        ),
                      if (isBool == true && st.contains("SU")) new Text(""),
                      if (isBool == true && st.contains("SU"))
                        new Text(
                          'Sıradaki sulama tarihi: ' + otherDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      if (isBool == false && st.contains("SU"))
                        new Text(
                          'SULANMADI',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.withOpacity(1.0)),
                          textAlign: TextAlign.center,
                        )
                      else if (isBool == true && st.contains("GÜBRE"))
                        new Text(
                          'GÜBRELENDİ',
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.purple[800]),
                          textAlign: TextAlign.center,
                        ),
                      if (isBool == true && st.contains("GÜBRE")) new Text(""),
                      if (isBool == true && st.contains("GÜBRE"))
                        new Text(
                          'Sıradaki gübreleme tarihi: ' + otherDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      if (isBool == false && st.contains("GÜBRE"))
                        new Text(
                          'GÜBRELENMEDİ',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.withOpacity(1.0)),
                          textAlign: TextAlign.center,
                        )
                      else if (isBool == true && st.contains("İLAÇ"))
                        new Text(
                          'İLAÇLANDI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.purple[800]),
                        ),
                      if (isBool == true && st.contains("İLAÇ")) new Text(""),
                      if (isBool == true && st.contains("İLAÇ"))
                        new Text(
                          'Sıradaki ilaçlama tarihi: ' + otherDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      if (isBool == false && st.contains("İLAÇ"))
                        new Text(
                          'İLAÇLANMADI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.withOpacity(1.0)),
                        )
                      else if (isBool == true && st.contains("HASAT"))
                        new Text(
                          'TOPLANDI',
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.purple[800]),
                          textAlign: TextAlign.center,
                        ),
                      if (isBool == true && st.contains("HASAT")) new Text(""),
                      if (isBool == true && st.contains("HASAT"))
                        new Text(
                          'Sıradaki toplama tarihi: ' + otherDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      if (isBool == false && st.contains("HASAT"))
                        new Text(
                          'TOPLANMADI',
                          textAlign: TextAlign.center,
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
    int kg = 0;
    int value = 0;
    DateTime now = new DateTime.now();
    String harvestDate = DateFormat('yMd').format(now);
    String whenHarvestDate = DateFormat('yMd').format(now);
    bool isHarvest = true;
    String irrigationDate = DateFormat('yMd').format(now);
    bool isIrrigation = true;
    String sprayDate = DateFormat('yMd').format(now);
    bool isSpray = true;
    String fertilizerDate = DateFormat('yMd').format(now);
    bool isFertilizer = true;
    return ChangeNotifierProvider(
      create: (context) => EntityProvider(widget.property),
      builder: (context, wid) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                widget.property.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.green[600], fontWeight: FontWeight.w700),
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
                      Navigator.pop(context);
                    })
              ],
              elevation: 0,
              backgroundColor: Colors.grey[200],
              iconTheme: new IconThemeData(color: Colors.green[600]),
            ),
            body: FutureBuilder(
              future: Provider.of<EntityProvider>(context).future,
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

                return Container(
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
                                  widget.property.all.length,
                                  widget.property.all,
                                  context),
                              detailCard(
                                  "TOPLAM HASTA AĞAÇ SAYISI",
                                  widget.property.diseased.length,
                                  widget.property.diseased,
                                  context),
                            ]),
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          detailCard(
                              "BU YIL DİKİLEN AĞAÇ SAYISI",
                              widget.property.all.length,
                              widget.property.all,
                              context),
                          detailCard(
                              "BU YIL ÖLEN AĞAÇ SAYISI",
                              widget.property.dead.length,
                              widget.property.dead,
                              context),
                        ]),
                        new Text(""),
                        new Text(
                          'ÜRÜN BİLGİSİ',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(1.0)),
                        ),
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          productCard("BU DÖNEM", true, context, kg, value,
                              harvestDate),
                          productCard(
                              "TOPLAM", true, context, kg, value, harvestDate),
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
                          otherCard(
                              "SULAMA BİLGİSİ",
                              isIrrigation,
                              irrigationDate,
                              context,
                              Color.fromARGB(255, 99, 181, 246)),
                          otherCard(
                              "GÜBRE BİLGİSİ",
                              isFertilizer,
                              fertilizerDate,
                              context,
                              Color.fromARGB(255, 141, 110, 99)),
                        ]),
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          otherCard("İLAÇLAMA BİLGİSİ", isSpray, sprayDate,
                              context, Color.fromARGB(255, 249, 168, 39)),
                          otherCard("HASAT BİLGİSİ", isHarvest, whenHarvestDate,
                              context, Color.fromARGB(255, 229, 115, 115)),
                        ]),
                      ]),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: "add",
              backgroundColor: Colors.green,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => newEntity(
                            property: widget.property,
                          )),
                ).then((value) {
                  setState(() {
                    print("update babyyy");
                    Provider.of<EntityProvider>(context, listen: false)
                        .updateFuture(widget.property);
                  });
                });
              },
            ));
      },
    );
  }
}
