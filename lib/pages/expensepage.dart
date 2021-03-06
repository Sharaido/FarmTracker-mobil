// aga be

import 'dart:developer';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart' as transactions;

class ExpensePage extends StatefulWidget {
  final String title;

  const ExpensePage({Key key, @required this.title}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _ExpensePageState extends State<ExpensePage> {
  final about = TextEditingController();
  final format = DateFormat("dd-MM-yyyy");
  final _formKey = GlobalKey<FormState>();
  DateTime date;
  final description = TextEditingController();
  final amount = TextEditingController();
  int i = 0;
  bool isExpense = false;

  final List<String> titles = <String>[
    'Test',
  ];
  final List<String> desc = <String>[
    'Description',
  ];
  final List<String> checkexpense = <String>[
    'false',
  ];
  final List<double> addamount = <double>[
    45,
  ];
  final List<int> dates = <int>[
    22051997,
  ];

  void addItemToList() {
    i++;
    setState(() {
      titles.insert(0, about.text);
      desc.insert(0, description.text);
      checkexpense.insert(0, isExpense.toString());
      addamount.insert(0, double.parse(amount.text));
      var x = date.day.toString();
      var y = date.month.toString();
      var z = date.year.toString();
      var f = x + y + z;
      dates.insert(0, int.parse(f));
      log(i.toString());
      transactions.Transaction(
        title: about.text,
        description: description.text,
        amount: double.parse(amount.text),
        isexpense: isExpense.toString(),
        date: int.parse(f),
      );
    });
  }

  Widget getBox(int index) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: FlatButton(
        color: checkexpense[index] == 'true'
            ? Colors.redAccent
            : Colors.greenAccent[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(
            color: checkexpense[index] == 'true' ? Colors.red : Colors.green,
            width: 4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 12, 5, 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Farm Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                '${titles[index]}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${addamount[index]}',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Text(
                    'TL',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
              Text(
                '${dates[index]}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  elevation: 10,
                  titlePadding: const EdgeInsets.fromLTRB(0, 0, 240, 0),
                  contentPadding: const EdgeInsets.all(5),
                  content: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        '${desc[index]}',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                );
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer('GELİR - GİDER'),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: new IconThemeData(color: Colors.green),
        title: Text(
          widget.title.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        tooltip: 'Add',
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              description.text = '';
              amount.text = '';
              about.text = '';
              return AlertDialog(
                scrollable: true,
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Gelir - Gider Ekle'),
                          SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Başlık boş kalamaz.';
                              }
                              return null;
                            },
                            controller: about,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Başlık',
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Açıklama boş kalamaz.';
                              }
                              return null;
                            },
                            controller: description,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Açıklama',
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Miktar boş kalamaz.';
                              }
                              return null;
                            },
                            controller: amount,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Miktar',
                            ),
                          ),
                          SizedBox(height: 15),
                          DateTimeField(
                            validator: (value) {
                              if (value == null) {
                                return 'Lütfen tarih seçin.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Tarih',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              return date;
                            },
                          ),
                          SizedBox(height: 15),
                          CheckboxListTile(
                            title: const Text('Bu bir gider mi?'),
                            value: isExpense,
                            onChanged: (bool value) {
                              setState(() {
                                isExpense = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 320.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: Text(
                                    "İptal",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 50),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.green,
                                  onPressed: () {
                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }
                                    addItemToList();
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: Text(
                                    "Kaydet",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      body: Container(
        child: GridView.count(
          childAspectRatio: 1.25,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 2,
          padding: const EdgeInsets.all(15),
          children: List.generate(
            titles.length,
            (index) {
              return getBox(index);
            },
          ),
        ),
      ),
    );
  }
}
