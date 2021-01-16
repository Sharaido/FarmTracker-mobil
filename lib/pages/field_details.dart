import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/models/field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'entity_details.dart';
import 'newEntity.dart';

class EntityProvider extends ChangeNotifier {
  Future future;

  EntityProvider(Property property) {
    API.getAllEntities(property.id).then((value) {
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
    API.getAllEntities(property.id).then((value) {
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

class _FieldDetailsState extends State<FieldDetails> {
  bool fertilizerValue = false;
  bool sprayValue = false;
  bool irrigationValue = false;
  bool harvestValue = false;
  String image = "pine_tree.png";
  TextEditingController kgController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController skgController = TextEditingController();
  TextEditingController svalueController = TextEditingController();

  Widget noButton(Entity entity, context) {
    Color color;
    switch (entity.health) {
      case HealthStatus.HEALTHY:
        color = Colors.green;
        break;
      case HealthStatus.DISEASED:
        color = Colors.orange;
        break;
      case HealthStatus.DEAD:
        color = Colors.black;
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: color,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EntityDetails(
                      entity: entity,
                    )),
          ).then((value) {
            setState(() {
              Navigator.pop(context);
              Provider.of<EntityProvider>(context, listen: false)
                  .updateFuture(widget.property);
              refreshIndicatorKey.currentState.show();
            });
          });
        },
        child: FittedBox(
          child: Text(
            entity.fakeID,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Container(
                                height: no.length.toDouble() * 5 +
                                    50, // ibret vol.2 no.length.toDouble() + 10
                                width: MediaQuery.of(context).size.width * .0,
                                color: Colors.white,
                                child: GridView.count(
                                  childAspectRatio: 1,
                                  crossAxisCount:
                                      6, //(no.length / 20).toInt() + 5 ibret alın
                                  children: List.generate(no.length, (index) {
                                    return noButton(no[index], context);
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
                                    ).then((value) {
                                      setState(() {
                                        Provider.of<EntityProvider>(context,
                                                listen: false)
                                            .updateFuture(widget.property);
                                        Navigator.of(context).pop();
                                      });
                                    });
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
                            fontSize: 18.0,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      if (st.contains("HASTA"))
                        Image(
                          image: AssetImage("assets/images/pine_tree_fire.png"),
                          fit: BoxFit.fitHeight,
                          height: 25,
                        )
                      else if (st.contains("DİKİLEN"))
                        Image(
                          image: AssetImage("assets/images/newtree.png"),
                          fit: BoxFit.fitHeight,
                          height: 25,
                        )
                      else if (st.contains("ÖLEN"))
                        Image(
                          image: AssetImage("assets/images/pine_tree.png"),
                          color: Colors.black,
                          fit: BoxFit.fitHeight,
                          height: 25,
                        )
                      else
                        Image(
                          image: AssetImage("assets/images/pine_tree.png"),
                          fit: BoxFit.fitHeight,
                          height: 25,
                        ),
                      new Text(
                        count.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
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
                              title: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Column(
                                  children: [
                                    Text(
                                      st,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (st.toString().contains("TOPLAM"))
                                      productEntry(),
                                    if (st.toString().contains("DÖNEM"))
                                      seasonEntry(),
                                  ],
                                );
                              }),
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
                      if (st.contains("TOPLAM"))
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        )
                      else
                        Icon(
                          Icons.shopping_basket,
                          color: Colors.white,
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
                        "" + harvestDate.toString(),
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

  Widget otherCard(String st, isDone, otherDate, context, Color color) {
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
                              title: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Column(
                                  children: [
                                    Text(
                                      st,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (1 == 1 && st.contains("SU"))
                                      Column(children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Checkbox(
                                                value: irrigationValue,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    irrigationValue = value;
                                                    refreshIndicatorKey
                                                        .currentState
                                                        .show();
                                                  });
                                                }),
                                            Text("Sulandı"),
                                          ],
                                        ),
                                        Text(
                                          "\n Sıradaki Sulama tarihi:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color:
                                                  Colors.blue.withOpacity(1.0)),
                                          textAlign: TextAlign.center,
                                        ),
                                        irrigationPick(),
                                      ]),
                                    if (1 == 1 && st.contains("GÜBRE"))
                                      Column(children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Checkbox(
                                                value: fertilizerValue,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    fertilizerValue = value;
                                                    refreshIndicatorKey
                                                        .currentState
                                                        .show();
                                                  });
                                                }),
                                            Text("Gübrelendi"),
                                          ],
                                        ),
                                        Text(
                                          "\nSıradaki Gübre tarihi:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color:
                                                  Colors.blue.withOpacity(1.0)),
                                          textAlign: TextAlign.center,
                                        ),
                                        fertilizerPick(),
                                      ]),
                                    if (1 == 1 && st.contains("İLAÇ"))
                                      Column(children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Checkbox(
                                                value: sprayValue,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    sprayValue = value;
                                                    refreshIndicatorKey
                                                        .currentState
                                                        .show();
                                                  });
                                                }),
                                            Text("İlaçlandı"),
                                          ],
                                        ),
                                        Text(
                                          "\n Sıradaki İlaçlama tarihi:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color:
                                                  Colors.blue.withOpacity(1.0)),
                                          textAlign: TextAlign.center,
                                        ),
                                        sprayPick()
                                      ]),
                                    if (1 == 1 && st.contains("HASAT"))
                                      Column(children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Checkbox(
                                                value: harvestValue,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    harvestValue = value;
                                                    refreshIndicatorKey
                                                        .currentState
                                                        .show();
                                                  });
                                                }),
                                            Text("Toplandı"),
                                          ],
                                        ),
                                        Text(
                                          "\n Sıradaki Hasat tarihi:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color:
                                                  Colors.blue.withOpacity(1.0)),
                                          textAlign: TextAlign.center,
                                        ),
                                        harvestPick()
                                      ]),
                                  ],
                                );
                              }),
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
                      if (st.contains("SU"))
                        Icon(
                          Icons.wash,
                          color: Colors.white,
                        )
                      else if (st.contains("GÜBRE"))
                        Icon(
                          Icons.nature_rounded,
                          color: Colors.white,
                        )
                      else if (st.contains("İLAÇ"))
                        Icon(
                          Icons.sanitizer,
                          color: Colors.white,
                        )
                      else if (st.contains("HASAT"))
                        Icon(
                          Icons.shopping_basket,
                          color: Colors.white,
                        ),
                      if (irrigationValue && st.contains("SU"))
                        new Text(
                          'SULANDI',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.purple[800]),
                          textAlign: TextAlign.center,
                        ),
                      //if (isDone == true && st.contains("SU")) new Text(""),
                      if (irrigationValue && st.contains("SU"))
                        new Text(
                          '' + otherDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      if (!irrigationValue && st.contains("SU"))
                        new Text(
                          'SULANMADI',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.red.shade900),
                          textAlign: TextAlign.center,
                        )
                      else if (fertilizerValue == true && st.contains("GÜBRE"))
                        new Text(
                          'GÜBRELENDİ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.purple[800]),
                          textAlign: TextAlign.center,
                        ),
                      if (fertilizerValue && st.contains("GÜBRE"))
                        new Text(
                          '' + otherDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      if (!fertilizerValue && st.contains("GÜBRE"))
                        new Text(
                          'GÜBRELENMEDİ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.red.shade900),
                          textAlign: TextAlign.center,
                        )
                      else if (sprayValue && st.contains("İLAÇ"))
                        new Text(
                          'İLAÇLANDI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.purple[800]),
                        ),
                      if (sprayValue && st.contains("İLAÇ"))
                        new Text(
                          '' + otherDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      if (!sprayValue && st.contains("İLAÇ"))
                        new Text(
                          'İLAÇLANMADI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.red.shade900),
                        )
                      else if (harvestValue && st.contains("HASAT"))
                        new Text(
                          'TOPLANDI',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.purple[800]),
                          textAlign: TextAlign.center,
                        ),
                      if (harvestValue && st.contains("HASAT"))
                        new Text(
                          '' + otherDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      if (!harvestValue && st.contains("HASAT"))
                        new Text(
                          'TOPLANMADI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.red.shade900),
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

  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    int kg = 0;
    int value = 0;
    DateTime now = new DateTime.now();
    String harvestDate = DateFormat('yMd').format(now);
    String whenHarvestDate = DateFormat('yMd').format(now);
    String irrigationDate = DateFormat('yMd').format(now);
    String sprayDate = DateFormat('yMd').format(now);
    String fertilizerDate = DateFormat('yMd').format(now);
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
          body: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              await new Future.delayed(new Duration(seconds: 0));
              setState(() {});
              return null;
            },
            child: FutureBuilder(
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

                return SingleChildScrollView(
                  child: Container(
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
                                    "TOPLAM AĞAÇ",
                                    widget.property.all.length,
                                    widget.property.all,
                                    context),
                                detailCard(
                                    "HASTA AĞAÇ",
                                    widget.property.diseased.length,
                                    widget.property.diseased,
                                    context),
                              ]),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                detailCard(
                                    "DİKİLEN AĞAÇ",
                                    widget.property.all.length,
                                    widget.property.all,
                                    context),
                                detailCard(
                                    "ÖLEN AĞAÇ",
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
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                productCard("BU DÖNEM", true, context, kg,
                                    value, harvestDate),
                                productCard("TOPLAM", true, context, kg, value,
                                    harvestDate),
                              ]),
                          new Text(""),
                          new Text(
                            'DİĞER BİLGİLER',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(1.0)),
                          ),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                otherCard(
                                    "SULAMA BİLGİSİ",
                                    irrigationValue,
                                    irrigationDate,
                                    context,
                                    Color.fromARGB(255, 99, 181, 246)),
                                otherCard(
                                    "GÜBRE BİLGİSİ",
                                    fertilizerValue,
                                    fertilizerDate,
                                    context,
                                    Color.fromARGB(255, 141, 110, 99)),
                              ]),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                otherCard("İLAÇ BİLGİSİ", sprayValue, sprayDate,
                                    context, Color.fromARGB(255, 249, 168, 39)),
                                otherCard(
                                    "HASAT BİLGİSİ",
                                    harvestValue,
                                    whenHarvestDate,
                                    context,
                                    Color.fromARGB(255, 229, 115, 115)),
                              ]),
                        ]),
                  ),
                );
              },
            ),
          ),
          /*floatingActionButton: FloatingActionButton(
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
                    Provider.of<EntityProvider>(context, listen: false)
                        .updateFuture(widget.property);
                  });
                });
              },
            )*/
        );
      },
    );
  }
}
