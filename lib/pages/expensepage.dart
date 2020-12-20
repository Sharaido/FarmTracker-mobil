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

class DescExtend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
    );
  }
}

DateTime date;

// ignore: must_be_immutable
class BasicDateField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DateTimeField(
          decoration: InputDecoration(
            labelText: 'Date',
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
            print(date.day);
            print(date.month);
            print(date.year);
            return date;
          },
        ),
      ],
    );
  }
}

class _ExpensePageState extends State<ExpensePage> {
  final about = TextEditingController();
  final description = TextEditingController();
  final amount = TextEditingController();
  int i = 0;
  bool isExpense = false;

  final List<String> titles = <String>[
    'Dayıoğluna borç',
  ];
  final List<String> desc = <String>[
    'Aga beee böyle de borç yapılır mı',
  ];
  final List<String> checkexpense = <String>[
    'true',
  ];
  final List<double> addamount = <double>[
    45,
  ];
  final List<int> dates = <int>[
    22051997,
  ];


FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }


  void addItemToList() {
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

      transactions.Transaction(
        title: about.text,
        description: description.text,
        amount: double.parse(amount.text),
        isexpense: isExpense.toString(),
        date: int.parse(f),
      );
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer('INCOME - EXPANSE'),
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: titles.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      color: checkexpense[i] == 'true'
                          ? Colors.red[500]
                          : Colors.green[500],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 70,
                  margin: EdgeInsets.all(2),
                  child: Center(
                    child: SizedBox(
                      height: 70,
                      width: 340,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          side: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          DescExtend();
                        },
                        child: Text(
                          '${titles[index]}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Material(
            elevation: 10,
            shadowColor: Color(0xFFFF8C3B),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Text('Sort by:'),
                  Material(
                    elevation: 10,
                    shape: CircleBorder(
                      side: BorderSide(width: 0),
                    ),
                    shadowColor: Colors.black,
                    child: ButtonTheme(
                      minWidth: 7,
                      child: FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(20.0),
                        color: Colors.green,
                        shape: CircleBorder(
                          side: BorderSide(
                            width: 0,
                          ),
                        ),
                        child: Text(
                          'Date',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 10,
                    shape: CircleBorder(
                      side: BorderSide(width: 0),
                    ),
                    shadowColor: Colors.black,
                    child: ButtonTheme(
                      minWidth: 7,
                      child: FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(20.0),
                        color: Colors.green,
                        shape: CircleBorder(
                          side: BorderSide(
                            width: 0,
                          ),
                        ),
                        child: Text(
                          'Expe',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 10,
                    shape: CircleBorder(
                      side: BorderSide(width: 0),
                    ),
                    shadowColor: Colors.black,
                    child: ButtonTheme(
                      minWidth: 7,
                      child: FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(20.0),
                        color: Colors.green,
                        shape: CircleBorder(
                          side: BorderSide(
                            width: 0,
                          ),
                        ),
                        child: Text(
                          'Amnt',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                        height: MediaQuery.of(context).size.height / 1.25,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Add Income/Expense'),
                                SizedBox(height: 15),
                                TextField(
                                  controller: about,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: 'Title',
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: description,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: 'Description',
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  onTap: () => myFocusNode.requestFocus(),
                                  controller: amount,
                                  focusNode: myFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: 'Amount',
                                  ),
                                ),
                                SizedBox(height: 15),
                                BasicDateField(),
                                SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Is it an expense?'),
                                  value: isExpense,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isExpense = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: Row(children: [
                                    RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                   RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.green,
                                    onPressed: () {
                                      if (about.text != '') {
                                        addItemToList();
                                        print(dates);
                                      } else {
                                        AlertDialog(
                                          title: Text('Error'),
                                        );
                                      }
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  
                                  ],
                                ),
                                ),
                              ],
                            ),
                          ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
