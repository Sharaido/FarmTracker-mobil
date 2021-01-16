import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/my_fields.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class NewFieldModal extends StatefulWidget {
  final String jwt;
  NewFieldModal(this.jwt);

  @override
  _NewFieldModalState createState() => _NewFieldModalState();
}

class _NewFieldModalState extends State<NewFieldModal> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  bool _hasError = false;

  String _nameValidator(String value) {
    if (value == '') return 'Boş bırakılamaz';
    if (value.length < 3) return 'En az 3 karakter giriniz';
    return null;
  }

  _onAddPressed() {
    if (!_formKey.currentState.validate()) return;
    API.createFarm(_nameController.text, _descController.text).then((value) {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        height: MediaQuery.of(context).size.height / 2.1,
        width: MediaQuery.of(context).size.height / 2.3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Yeni Tarla Ekle'.toUpperCase(),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
            ),
            if (_hasError)
              Text(
                'Bu üyelik türü için maksimum tarla limitine ulaştınız.',
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
                  SizedBox(
                    height: 15,
                  ),
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
