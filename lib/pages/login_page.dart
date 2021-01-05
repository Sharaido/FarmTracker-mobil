import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/register_page.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'my_fields.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<String> get _loginResult async {
    if (__loginResult != null) {
      return __loginResult;
    }
    storage.read(key: "token").then((value) {
      return value;
    });

    var jwt = await storage.read(key: "token");
    var expire = await storage.read(key: "expire");
    if (DateTime.parse(expire).isAfter(DateTime.now())) {
      return '{"result": true, "expiration":"$expire", "token":"$jwt"}';
    }

    return '{"result":false}';
  }

  Future<String> __loginResult;

  set _loginResult(Future<String> str) {
    __loginResult = str;
  }

  final _formKey = new GlobalKey<FormState>();
  bool _hidePass = true;

  Future<String> tryLogin(String username, String password) async {
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

    var body = json.decode(response.body);

    if (body['result']) {
      var jwt = body['token'];
      var expires = body['expiration'];
      await storage.write(key: "token", value: jwt);
      await storage.write(key: "expire", value: expires);
      return '{"result": true, "expiration":"$expires", "token":"$jwt"}';
    }

    return '{"result":false}';
  }

  _onLoginPressed() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _loginResult =
          tryLogin(_usernameController.text, _passwordController.text);
    });
  }

  _onRegisterPressed() async {
    await Navigator.of(context).push(routeBottomToUp(RegisterPage()));
  }

  _onShowPassClicked() {
    setState(() {
      _hidePass = !_hidePass;
    });
  }

  _getContent(bool hasError) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Spacer(),
          Text(
            'Farm Tracker',
            style: TextStyle(
                fontSize: 25,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30.0,
          ),
          if (hasError)
            Text(
              'Üye bilgileri bulunamadı',
              style: TextStyle(
                  fontSize: 17, color: Colors.red, fontWeight: FontWeight.bold),
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
          SizedBox(
            height: 40.0,
          ),
          getButton(Colors.green, 'GİRİŞ YAP', Colors.white, _onLoginPressed),
          getButton(Colors.white, 'KAYIT OL', Colors.black, _onRegisterPressed),
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
    if (value == '') return 'Boş kalamaz';
    return null;
  }

  String _passwordValidator(String value) {
    if (value == '') return 'Boş kalamaz';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[200],
          child: Center(
            child: FutureBuilder(
              future: _loginResult,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = json.decode(snapshot.data);
                  if (data['result']) {
                    Future.delayed(Duration.zero, () async {
                      _loginResult = Future<String>.value(null);
                      var jwt = data['token'];
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyFields(jwt: jwt),
                        ),
                      );
                    });
                  } else {
                    return _getContent(true);
                  }
                } else {
                  return _getContent(false);
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}

_getLabel(String label) {
  return Container(
    margin: const EdgeInsets.only(top: 10, left: 35, right: 20),
    child: Text(
      label,
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    ),
  );
}

getTextField(TextEditingController controller, String label, bool hideText,
    TextInputType type, Icon icon, Function iconAction, Function validator) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _getLabel(label),
      Container(
        height: 50,
        margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 3.5,
                spreadRadius: -3,
                offset: Offset(0, 2),
              ),
            ]),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                autofocus: false,
                controller: controller,
                keyboardType: type,
                autocorrect: true,
                obscureText: hideText,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    errorStyle: TextStyle(
                      fontSize: 15,
                    ),
                    border: InputBorder.none),
                validator: validator,
              ),
            ),
            if (icon != null) IconButton(icon: icon, onPressed: iconAction),
          ],
        ),
      ),
    ],
  );
}

getButton(Color color, String text, Color textColor, Function onPressed) {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 6.0,
          spreadRadius: -4,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: color,
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
    ),
  );
}
