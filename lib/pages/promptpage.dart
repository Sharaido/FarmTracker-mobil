/*import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class PromtPage extends StatefulWidget {
  @override
  _PromtPageState createState() => _PromtPageState();
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

class _PromtPageState extends State<PromtPage> {
  final title = TextEditingController();
  final description = TextEditingController();
  final amount = TextEditingController();
  bool isExpense = false;
  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    description.dispose();
    title.dispose();
    amount.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
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
            RaisedButton(
              padding: const EdgeInsets.all(0.0), // içten boşluk
              child: Text('Submit'),
              onPressed: (){
              
                return showDialog(
                    context: context,
                    builder: (context) {
                return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(description.text),
               );
              },
             );
            },
           ),
          ],
        ),
      ),
    );
   }
  }
*/

