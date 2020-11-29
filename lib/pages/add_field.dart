import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/my_fields.dart';
import 'package:http/http.dart' as http;

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
    if (value == '') return 'Required';
    if (value.length < 3) return 'Must be at least 3 characters';
    return null;
  }

  Future<bool> addFarm(String name, String desc) async {
    final http.Response response = await http.post(
      'http://10.0.2.2:8181/api/Farms/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.jwt}',
      },
      body: jsonEncode(<String, String>{
        'Name': name,
        'Description': desc,
      }),
    );
    return response.statusCode == 201;
  }

  _onAddPressed() {
    if (!_formKey.currentState.validate()) return;
    addFarm(_nameController.text, _descController.text).then((value) {
      if (value) {
        setState(() {
          _hasError = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyFields(jwt: widget.jwt),
          ),
        );
      } else {
        setState(() {
          _hasError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'ADD A NEW FIELD',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 25,
              ),
            ),
          ),
          if (_hasError)
            Text(
              'A problem occured, please try again.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
              ),
            ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                getTextField(
                    _nameController, 'NAME', false, null, null, _nameValidator),
                getTextField(
                    _descController, 'DESCRIPTION', false, null, null, null),
                SizedBox(
                  height: 15,
                ),
                getButton(Colors.green, 'ADD', Colors.white, _onAddPressed),
              ],
            ),
          )
        ],
      ),
    );
  }
}
