import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/models/field.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class EntityDetailProvider extends ChangeNotifier {
  Future future;
  Map<String, EntityDetail> detailMap;

  EntityDetailProvider(Entity entity) {
    API.getEntityDetails(entity.id).then((value) {
      detailMap = Map.fromIterable(value, key: (d) => d.name, value: (d) => d);
      future = API.getCategory(entity.categoryID);
      notifyListeners();
    });
  }
}

class EntityDetails extends StatefulWidget {
  final Entity entity;

  const EntityDetails({Key key, this.entity}) : super(key: key);

  @override
  _EntityDetailsState createState() => _EntityDetailsState();
}

class _EntityDetailsState extends State<EntityDetails> {
  String image;
  Color healthColor;
  String healthText;
  double screenWidth;
  IconData healthIcon;

  setValues() {
    switch (widget.entity.health) {
      case HealthStatus.HEALTHY:
        image = "assets/images/healthytree.png";
        healthText = "SAĞLIKLI";
        healthColor = Colors.green;
        healthIcon = Icons.sentiment_very_satisfied;
        break;
      case HealthStatus.DISEASED:
        image = "assets/images/sicktree.png";
        healthText = "HASTA";
        healthColor = Colors.orange[700];
        healthIcon = Icons.sentiment_neutral;
        break;
      case HealthStatus.DEAD:
        image = "assets/images/deadtree.png";
        healthText = "ÖLÜ";
        healthColor = Colors.black;
        healthIcon = Icons.sentiment_very_dissatisfied;
        break;
    }
  }

  getOpposite(String text) {
    var result = "";

    switch (text) {
      case "SULANDI":
        result = "SULANMADI";
        break;
      case "GÜBRELENDİ":
        result = "GÜBRELENMEDİ";
        break;
      case "İLAÇLANDI":
        result = "İLAÇLANMADI";
        break;
      case "HASAT EDİLDİ":
        result = "HASAT EDİLMEDİ";
        break;
    }
    return result;
  }

  getHealthText() {
    return Row(
      children: [
        Icon(
          healthIcon,
          color: healthColor,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(
              healthText,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: healthColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  getNumberBox() {
    return Positioned.fill(
      right: 25,
      bottom: 60,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1.5)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Text(
              widget.entity.fakeID,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  getCheckText(
      IconData icon, Color color, String dateText, String text, bool isDone) {
    return [
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Icon(
            icon,
            color: isDone ? color : Colors.grey,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                isDone
                    ? "EN SON - $dateText\n$text"
                    : "EN SON - $dateText\n" + getOpposite(text),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDone ? color : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      )
    ];
  }

  getIconButton(IconData icon, String text, EntityDetail detail,
      Color buttonColor, Color borderColor, bool isActive) {
    return Column(
      children: [
        !isDateAfter(detail.remainderDate)
            ? Icon(
                Icons.warning,
                color: Colors.red,
              )
            : SizedBox(
                height: 24,
              ),
        Container(
          width: screenWidth / 5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isActive ? buttonColor : Colors.grey,
              border: Border.all(
                  color: isActive ? borderColor : Colors.grey[600],
                  width: 1.5)),
          child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: isActive ? () {} : null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    parseDate(detail.remainderDate),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    setValues();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
        create: (context) => EntityDetailProvider(widget.entity),
        builder: (context, wid) {
          var provider = Provider.of<EntityDetailProvider>(context);
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "${widget.entity.fakeID} NUMARALI BİTKİ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.green[600], fontWeight: FontWeight.w700),
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        //Navigator.popUntil(context, ModalRoute.withName('/'));
                      })
                ],
                elevation: 0,
                backgroundColor: Colors.grey[200],
                iconTheme: new IconThemeData(color: Colors.green[600]),
              ),
              body: FutureBuilder(
                future: provider.future,
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
                    return Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(children: [
                                Image(
                                  image: AssetImage(image),
                                  fit: BoxFit.fitHeight,
                                  height: 270,
                                ),
                                if (widget.entity.health != HealthStatus.DEAD)
                                  getNumberBox()
                              ]),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data.name.toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 24,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      new DateFormat("dd/MM/yyyy")
                                          .format(DateTime.parse(
                                              widget.entity.createdDate))
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    getHealthText(),
                                    ...getCheckText(
                                        Icons.wash,
                                        Colors.blue,
                                        parseDate(provider.detailMap['water']
                                            .remainderCompletedDate),
                                        "SULANDI",
                                        isDateAfter(provider
                                            .detailMap['water'].remainderDate)),
                                    ...getCheckText(
                                        Icons.nature_rounded,
                                        Colors.brown,
                                        parseDate(provider
                                            .detailMap['fertilizer']
                                            .remainderCompletedDate),
                                        "GÜBRELENDİ",
                                        isDateAfter(provider
                                            .detailMap['fertilizer']
                                            .remainderDate)),
                                    ...getCheckText(
                                        Icons.sanitizer,
                                        Colors.yellow[800],
                                        parseDate(provider.detailMap['spray']
                                            .remainderCompletedDate),
                                        "İLAÇLANDI",
                                        isDateAfter(provider
                                            .detailMap['spray'].remainderDate)),
                                    ...getCheckText(
                                        Icons.shopping_basket,
                                        Colors.red[300],
                                        parseDate(provider.detailMap['harvest']
                                            .remainderCompletedDate),
                                        "HASAT EDİLDİ",
                                        isDateAfter(provider
                                            .detailMap['harvest']
                                            .remainderDate)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              getIconButton(
                                Icons.wash,
                                "SULA",
                                provider.detailMap['water'],
                                Colors.blue[300],
                                Colors.blue,
                                true,
                              ),
                              getIconButton(
                                Icons.nature_rounded,
                                "GÜBRELE",
                                provider.detailMap['fertilizer'],
                                Colors.brown[400],
                                Colors.brown,
                                true,
                              ),
                              getIconButton(
                                Icons.sanitizer,
                                "İLAÇLA",
                                provider.detailMap['spray'],
                                Colors.yellow[800],
                                Colors.yellow[900],
                                true,
                              ),
                              getIconButton(
                                Icons.shopping_basket,
                                "HASAT ET",
                                provider.detailMap['harvest'],
                                Colors.red[300],
                                Colors.red[400],
                                true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                      ),
                    ),
                  );
                },
              ));
        });
  }
}

String parseDate(String value) {
  return new DateFormat("dd/MM/yyyy").format(DateTime.parse(value)).toString();
}

bool isDateAfter(String value) {
  return DateTime.parse(value).isAfter(DateTime.now());
}
