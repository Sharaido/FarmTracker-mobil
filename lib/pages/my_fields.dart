import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/widgets/add_field.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';
import 'package:flutter_app/widgets/fieldcart.dart';
import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:http/http.dart' as http;

class FarmsFuture extends ChangeNotifier {
  Future future;

  FarmsFuture(this.future);

  void updateFuture(Future newFuture) {
    future = newFuture;
    notifyListeners();
  }
}

class MyFields extends StatefulWidget {
  final String jwt;

  MyFields({Key key, @required this.jwt}) : super(key: key);

  @override
  _MyFieldsState createState() => _MyFieldsState();
}

List<Farm> parseFarms(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Farm>((json) => Farm.fromJson(json)).toList();
}

class _MyFieldsState extends State<MyFields> {
  Future<List<Farm>> get _farms async {
    final response = await http.get('$BASE_URL/api/Farms/', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.jwt}',
    });
    return parseFarms(response.body);
  }

  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  FarmsFuture farmsFuture;

  Future<Null> _getFarms() async {
    await new Future.delayed(new Duration(seconds: 0));
    setState(() {
      farmsFuture.updateFuture(_farms);
    });
    return null;
  }

  _onAddField(context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              elevation: 10,
              contentPadding: EdgeInsets.all(0),
              content: new NewFieldModal(widget.jwt));
        }).then((value) {
      setState(() {
        farmsFuture.updateFuture(_farms);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FarmsFuture(_farms),
      builder: (context, wdg) {
        farmsFuture = Provider.of<FarmsFuture>(context, listen: false);
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'My fields'.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.green[600], fontWeight: FontWeight.w700),
              ),
              elevation: 0,
              backgroundColor: Colors.grey[200],
              iconTheme: new IconThemeData(color: Colors.green[600]),
            ),
            body: FutureBuilder(
              future: Provider.of<FarmsFuture>(context, listen: false).future,
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
                    onRefresh: _getFarms,
                    child: Container(
                      color: Colors.grey[200],
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 70, top: 10),
                        cacheExtent: 100,
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(12, 3, 12, 5),
                            child: FieldCard(field: snapshot.data[index]),
                          );
                        },
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  key: refreshIndicatorKey,
                  onRefresh: _getFarms,
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        'No Farms',
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
            drawer: CustomDrawer('MY FIELDS'),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _onAddField(context);
              },
              child: Icon(Icons.add),
            ));
      },
    );
  }
}
