import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/my_fields.dart';
import 'package:flutter_app/pages/test-pages/farm_properties.dart';
import 'package:http/http.dart' as http;

class NewPropertyModal extends StatefulWidget {
  final String jwt;
  final Farm farm;
  NewPropertyModal(this.jwt, this.farm);

  @override
  _NewPropertyModalState createState() => _NewPropertyModalState();
}

class _NewPropertyModalState extends State<NewPropertyModal> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  bool _hasError = false;
  var selectedValue = 1;

  String _nameValidator(String value) {
    if (value == '') return 'Boş kalamaz';
    if (value.length < 3) return 'En az 3 karakter olmalı';
    return null;
  }

  Future<bool> addProperty(
      String name, String desc, int category, String farmID) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Farms/Properties',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.jwt}',
      },
      body: jsonEncode(<String, dynamic>{
        'Name': name,
        'Description': desc,
        'CUID': category,
        'FUID': farmID,
      }),
    );
    return response.statusCode == 201;
  }

  _onAddPressed() {
    if (!_formKey.currentState.validate()) return;
    addProperty(_nameController.text, _descController.text, selectedValue,
            widget.farm.id)
        .then((value) {
      if (value) {
        setState(() {
          _hasError = false;
        });

        Navigator.pop(context);
      } else {
        setState(() {
          _hasError = true;
        });
      }
    });
  }

  _setSelectedRadio(int val) {
    setState(() {
      selectedValue = val;
    });
  }

  _getRadioButtons() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('BİTKİ'),
        Radio(
          value: 1,
          groupValue: selectedValue,
          activeColor: Colors.green,
          onChanged: (val) {
            _setSelectedRadio(val);
          },
        ),
        Text('HAYVAN'),
        Radio(
          value: 2,
          groupValue: selectedValue,
          activeColor: Colors.blue,
          onChanged: (val) {
            _setSelectedRadio(val);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        height: MediaQuery.of(context).size.height / 1.9,
        width: MediaQuery.of(context).size.height / 2.3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'YENİ ALAN EKLE',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
            ),
            if (_hasError)
              Text(
                'Bu üyelik türü için maksimum alan limitine ulaştınız.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  getTextField(_nameController, 'İSİM', false,
                      TextInputType.text, null, null, _nameValidator),
                  getTextField(_descController, 'AÇIKLAMA', false,
                      TextInputType.text, null, null, null),
                  _getRadioButtons(),
                  getButton(Colors.green, 'EKLE', Colors.white, _onAddPressed),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
