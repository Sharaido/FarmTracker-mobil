import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types

// ignore: camel_case_types
class newEntity extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<newEntity> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String dropdownValue = '(Boş)';
  String dropdownType = '(Boş)';
  String dropdownSpecies = '(Boş)';
  bool checkBoxValue = false;
  bool checkBoxValueNew = false;

  Widget dropDownwidget(context, {List<DropdownMenuItem<String>> items}) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: items,
    );
  }

  Widget dropDownwidgetType(context, {List<DropdownMenuItem<String>> items}) {
    return DropdownButton<String>(
      value: dropdownType,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownType = newValue;
        });
      },
      items: items,
    );
  }

  Widget dropDownwidgetSpecies(context,
      {List<DropdownMenuItem<String>> items}) {
    return DropdownButton<String>(
      value: dropdownSpecies,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownSpecies = newValue;
        });
      },
      items: items,
    );
  }

  Widget checkWidget(String value) {
    return Checkbox(
        value: checkBoxValue,
        onChanged: (bool value) {
          setState(() {
            checkBoxValue = value;
          });
        });
  }

  Widget checkWidgetNew(String value) {
    return Checkbox(
        value: checkBoxValueNew,
        onChanged: (bool value) {
          setState(() {
            checkBoxValueNew = value;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'ÜRÜN EKLE',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(1.0)),
            ),
            dropDownwidget(context,
                items: <String>['(Boş)', 'Ağaç', 'Çiçek']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
            dropDownwidgetType(context,
                items: <String>[
                  '(Boş)',
                  'Ceviz Ağacı',
                  'Ihlamur Ağacı',
                  'Meşe Ağacı',
                  'Zeytin Ağacı'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
            dropDownwidgetSpecies(context,
                items: <String>['(Boş)', 'Kara Ceviz', 'Boz Ceviz']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
            Container(
                padding: const EdgeInsets.fromLTRB(160, 0, 160, 0),
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      decoration: new InputDecoration(labelText: "Adet"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ],
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(140, 0, 140, 0),
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      decoration:
                          new InputDecoration(labelText: "Numara (Sayı-Sayı)"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <
                          TextInputFormatter>[], // Only numbers can be entered
                    ),
                  ],
                )),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              checkWidget("Hasta"),
              Text("Hasta"),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              checkWidgetNew("Yeni"),
              Text("Yeni"),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
