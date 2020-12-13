import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';
import 'package:intl/intl.dart';

class ExpensePage extends StatefulWidget {
  final String title;

  const ExpensePage({Key key, @required this.title}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Select Date',
        ),
        DateTimeField(
          format: format,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
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
  final title = TextEditingController();
  final description = TextEditingController();
  final amount = TextEditingController();
  bool isExpense = false;

  final List<String> names = <String>[
    'Aby',
    'Aish',
    'Ayan',
    'Ben',
    'Bob',
    'Charlie',
    'Cook',
    'Carline'
  ];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];

  TextEditingController nameController = TextEditingController();

  void addItemToList() {
    setState(() {
      names.insert(0, nameController.text);
      msgCount.insert(0, 0);
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
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  margin: EdgeInsets.all(2),
                  color: msgCount[index] >= 10
                      ? Colors.blue[400]
                      : msgCount[index] > 3
                          ? Colors.blue[100]
                          : Colors.grey,
                  child: Center(
                      child: Text(
                    '${names[index]} (${msgCount[index]})',
                    style: TextStyle(fontSize: 18),
                  )),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contact Name',
              ),
            ),
          ),
          RaisedButton(
            child: Text('Add'),
            onPressed: () {
              addItemToList();
            },
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
              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Add Income/Expense'),
                                TextField(
                                  controller: title,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Title',
                                  ),
                                ),
                                TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  controller: description,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Description',
                                  ),
                                ),
                                TextField(
                                  controller: amount,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Amount',
                                  ),
                                ),
                                BasicDateField(),
                                SizedBox(height: 15),
                                CheckboxListTile(
                                  title: const Text('Is it an expense?'),
                                  value: isExpense,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isExpense = value;
                                      print(isExpense);
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: RaisedButton(
                                    color: Colors.green,
                                    onPressed: () {},
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
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
        },
      ),
    );
  }
}

// Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => PromtPage()))
