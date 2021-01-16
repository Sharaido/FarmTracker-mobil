import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/widgets/add_income_expense.dart';
import 'package:flutter_app/widgets/add_property.dart';
import 'package:flutter_app/widgets/income_expense_card.dart';
import 'package:flutter_app/widgets/property_card.dart';
import 'package:provider/provider.dart';

class PropertyProvider extends ChangeNotifier {
  Future future;
  Future incomeFuture;
  Farm farm;

  PropertyProvider(this.future, this.incomeFuture, this.farm);

  void setFuture(Future newFuture) {
    future = newFuture;
    notifyListeners();
  }

  void setIncomeFuture(Future newFuture) {
    incomeFuture = newFuture;
    notifyListeners();
  }

  void updateFuture(String id) async {
    future = API.getProperties(id);
    notifyListeners();
  }

  void updateIncomeFuture() {
    incomeFuture = API.getIncomesExpenses(farm.id);
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
  final refreshIndicatorKey2 = GlobalKey<RefreshIndicatorState>();
  int currentTabIndex = 0;

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

  Widget propertyFutureBuilder(context) {
    return FutureBuilder(
      future: Provider.of<PropertyProvider>(context, listen: false).future,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget incomeFutureBuilder(context) {
    return FutureBuilder(
      future:
          Provider.of<PropertyProvider>(context, listen: false).incomeFuture,
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
            key: refreshIndicatorKey2,
            onRefresh: () async {
              await new Future.delayed(new Duration(seconds: 0));
              setState(() {
                Provider.of<PropertyProvider>(context, listen: false)
                    .setIncomeFuture(API.getIncomesExpenses(widget.farm.id));
              });
              return null;
            },
            child: Container(
              color: Colors.grey[200],
              child: GridView.count(
                childAspectRatio: 1.25,
                crossAxisCount: 2,
                children: List.generate(snapshot.data.length, (index) {
                  return IncomeExpenseCard(
                    incomeExpense: snapshot.data[index],
                    stateChanged: () {
                      setState(() {
                        refreshIndicatorKey2.currentState.show();
                      });
                    },
                  );
                }),
              ),
            ),
          );
        }
        return RefreshIndicator(
          key: refreshIndicatorKey2,
          onRefresh: () {},
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Text(
                'No Items',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PropertyProvider(API.getProperties(widget.farm.id),
          API.getIncomesExpenses(widget.farm.id), widget.farm),
      builder: (context, wid) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
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
                            content: currentTabIndex == 0
                                ? new NewPropertyModal(widget.jwt, widget.farm)
                                : new NewIncomeExpenseModal(widget.farm.id));
                      }).then((value) {
                    setState(() {
                      currentTabIndex == 0
                          ? Provider.of<PropertyProvider>(context,
                                  listen: false)
                              .setFuture(API.getProperties(widget.farm.id))
                          : Provider.of<PropertyProvider>(context,
                                  listen: false)
                              .setIncomeFuture(
                                  API.getIncomesExpenses(widget.farm.id));
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
                  IconButton(
                      icon: Icon(Icons.delete), onPressed: _onDeleteProperty)
                ],
                bottom: TabBar(
                  onTap: (index) {
                    setState(() {
                      currentTabIndex = index;
                    });
                  },
                  tabs: [
                    Tab(
                        icon: Icon(
                      Icons.agriculture,
                      color: Colors.green,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    )),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  propertyFutureBuilder(context),
                  incomeFutureBuilder(context),
                ],
              )),
        );
      },
    );
  }
}
