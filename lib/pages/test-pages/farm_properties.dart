import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/widgets/add_property.dart';
import 'package:flutter_app/widgets/property_card.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../main.dart';
import '../my_fields.dart';

class PropertyProvider extends ChangeNotifier {
  Future future;

  PropertyProvider(this.future);

  void setFuture(Future newFuture) {
    future = newFuture;
    notifyListeners();
  }

  void updateFuture(String id) async {
    var jwt = await storage.read(key: 'token');

    final response =
        await http.get('$BASE_URL/api/Farms/Properties/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    future = Future.value(
        parsed.map<Property>((json) => Property.fromJson(json)).toList());

    notifyListeners();
  }
}

class FarmProperties extends StatefulWidget {
  final Farm farm;
  final String jwt;

  const FarmProperties({Key key, this.farm, this.jwt}) : super(key: key);

  @override
  _FarmPropertiesState createState() => _FarmPropertiesState();
}

class _FarmPropertiesState extends State<FarmProperties> {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  _onDeleteProperty() async {
    final bool res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this farm?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("DELETE")),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
    if (!res) return;

    API.deleteFarm(widget.farm.id).then((value) {
      if (!value) return;

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PropertyProvider(API.getProperties(widget.farm.id)),
      builder: (context, wid) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        elevation: 10,
                        contentPadding: EdgeInsets.all(0),
                        content: new NewPropertyModal(widget.jwt, widget.farm));
                  }).then((value) {
                setState(() {
                  Provider.of<PropertyProvider>(context, listen: false)
                      .setFuture(API.getProperties(widget.farm.id));
                });
              });
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.farm.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green[600], fontWeight: FontWeight.w700),
            ),
            elevation: 0,
            backgroundColor: Colors.grey[200],
            iconTheme: new IconThemeData(color: Colors.green[600]),
            actions: [
              IconButton(icon: Icon(Icons.delete), onPressed: _onDeleteProperty)
            ],
          ),
          body: FutureBuilder(
            future:
                Provider.of<PropertyProvider>(context, listen: false).future,
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
                  onRefresh: () async {
                    await new Future.delayed(new Duration(seconds: 0));
                    setState(() {
                      Provider.of<PropertyProvider>(context, listen: false)
                          .setFuture(API.getProperties(widget.farm.id));
                    });
                    return null;
                  },
                  child: Container(
                    color: Colors.grey[200],
                    child: GridView.count(
                      childAspectRatio: 1.25,
                      crossAxisCount: 2,
                      children: List.generate(snapshot.data.length, (index) {
                        return PropertyCard(
                          property: snapshot.data[index],
                          stateChanged: () {
                            setState(() {
                              refreshIndicatorKey.currentState.show();
                            });
                          },
                        );
                      }),
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                key: refreshIndicatorKey,
                onRefresh: () {},
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'No Items',
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
        );
      },
    );
  }
}
