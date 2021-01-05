import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'my_fields.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  Future<bool> _loginResult;

  String _emailError;
  String _usernameError;

  bool _hidePass = true;

  final _formKey = new GlobalKey<FormState>();

  _getContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Spacer(),
          Text(
            'KAYIT',
            style: TextStyle(
                fontSize: 25,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          getTextField(_usernameController, 'KULLANICI ADI', false,
              TextInputType.text, null, null, _usernameValidator),
          getTextField(
              _passwordController,
              'ŞİFRE',
              _hidePass,
              TextInputType.text,
              Icon(Icons.remove_red_eye),
              _onShowPassClicked,
              _passwordValidator),
          getTextField(_emailController, 'E-POSTA', false,
              TextInputType.emailAddress, null, null, _emailValidator),
          getTextField(_nameController, 'İSİM', false, TextInputType.text, null,
              null, _nameValidator),
          getTextField(_surnameController, 'SOYİSİM', false, TextInputType.text,
              null, null, _nameValidator),
          SizedBox(
            height: 30.0,
          ),
          getButton(Colors.green, 'KAYIT OL', Colors.white, _onRegisterClicked),
          Container(
            margin:
                const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
            width: double.infinity,
          ),
          Spacer(),
        ],
      ),
    );
  }

  String _usernameValidator(String value) {
    if (value.trim().isEmpty) return "Required";
    if (value.length < 3) return "Must be longer than 3 characters";
    return _usernameError;
  }

  String _passwordValidator(String value) {
    if (value.trim().isEmpty) return "Boş kalamaz";
    if (value.length < 6) return "En az 6 karakter olmalı";
    return null;
  }

  String _emailValidator(String value) {
    if (value.trim().isEmpty) return "Boş kalamaz";
    if (!isEmailValid(value)) return "Lütfen e-posta adresi yazınız";
    return _emailError;
  }

  String _nameValidator(String value) {
    if (value.trim().isEmpty) return "Boş kalamaz";
    if (value.length < 1) return "Boş kalamaz";
    return null;
  }

  _onShowPassClicked() {
    setState(() {
      _hidePass = !_hidePass;
    });
  }

  _onRegisterClicked() async {
    bool r = await isEmailTaken(_emailController.text);
    _emailError = r ? "Bu e-posta alınmış" : null;

    r = await isUsernameTaken(_usernameController.text);
    _usernameError = r ? "Bu kullanıcı adı alınmış" : null;

    if (!_formKey.currentState.validate()) return;

    var guc = await getCodeForRegister();
    User user = new User(_usernameController.text, _passwordController.text,
        _emailController.text, _nameController.text, _surnameController.text);
    bool res = await tryRegister(user, guc);

    if (res) {
      Navigator.pop(context);
    }
  }

  bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  Future<bool> tryLogin(String username, String password) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Members/SignIn',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'SignInKey': username,
        'Password': password,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> isUsernameTaken(String username) async {
    final http.Response response =
        await http.get("$BASE_URL/api/Members/IsUsedUsername/$username");
    return response.body == 'true';
  }

  Future<bool> isEmailTaken(String email) async {
    final http.Response response =
        await http.get("$BASE_URL/api/Members/IsUsedEmail/$email");
    return response.body == 'true';
  }

  Future<String> getCodeForRegister() async {
    final http.Response response =
        await http.get("$BASE_URL/api/Members/GetNewUCodeForSignUp");
    return json.decode(response.body)['guc'];
  }

  Future<bool> tryRegister(User user, String guc) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Members/SignUp',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': user.username,
        'Password': user.password,
        'Email': user.email,
        'Name': user.name,
        'Surname': user.surname,
        'Guc': guc,
      }),
    );
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: _getContent(),
          ),
        ),
      ),
    );
  }
}
