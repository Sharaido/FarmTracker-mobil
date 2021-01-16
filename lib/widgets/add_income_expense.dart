import 'dart:developer';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:intl/intl.dart';

class NewIncomeExpenseModal extends StatefulWidget {
  final String farmID;

  NewIncomeExpenseModal(this.farmID);

  @override
  _NewIncomeExpenseModal createState() => _NewIncomeExpenseModal();
}

class _NewIncomeExpenseModal extends State<NewIncomeExpenseModal> {
  final _formKey = new GlobalKey<FormState>();
  final headController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  DateTime date;
  final descriptionController = TextEditingController();
  final costController = TextEditingController();
  bool isExpense = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
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
                    controller: headController,
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
                    controller: descriptionController,
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
                    controller: costController,
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
                            Navigator.of(context, rootNavigator: true).pop();
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
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            await API.createIncomeExpense(
                                widget.farmID,
                                date.toString(),
                                headController.text,
                                descriptionController.text,
                                double.parse(costController.text),
                                isExpense);
                            Navigator.of(context, rootNavigator: true).pop();
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
            ),
          ),
        );
      },
    );
  }
}
