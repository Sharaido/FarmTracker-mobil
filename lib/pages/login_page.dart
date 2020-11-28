import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../main.dart';
import 'my_fields.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  VideoPlayerController _controller;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _visible = false;
  bool _showError = false;
  bool _result;
  Future<bool> _loginResult;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller = VideoPlayerController.asset("assets/videos/background.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );
  }

  _getBackgroundColor() {
    return Container(
      color: Colors.grey.withAlpha(120),
    );
  }

  _getLoginButtons() {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        width: double.infinity,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.green,
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: const Text(
            'LOG IN',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            setState(() {
              _loginResult = tryLogin(_usernameController.text, _passwordController.text);
            });
          },
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        width: double.infinity,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.grey[200],
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: const Text(
            'REGISTER',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            _controller.pause();
            await Navigator.of(context).push(routeBottomToUp(RegisterPage()));
            _controller.play();
          },
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
        width: double.infinity,
      ),
      Spacer(),
    ];
  }

  _getContent(bool hasError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Spacer(),
        SizedBox(
          height: 50.0,
        ),
        if (hasError)
          Text(
            'Wrong username or password',
            style: TextStyle(fontSize: 17, fontFamily: 'Roboto', color: Colors.grey[200], fontWeight: FontWeight.bold),
          ),
        _getInputField(_usernameController, "USERNAME", false),
        _getInputField(_passwordController, "PASSWORD", true),
        SizedBox(
          height: 50.0,
        ),
        ..._getLoginButtons()
      ],
    );
  }

  _getInputField(TextEditingController controller, String label, bool isPass) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.black26,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        autocorrect: true,
        obscureText: isPass,
        style: TextStyle(color: Colors.grey[200], fontFamily: 'Roboto', fontSize: 18.0),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.green[400],
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none),
        validator: (String value) {
          if (value.trim().isEmpty) return "Required";
          return value;
        },
      ),
    );
  }

  Future<bool> tryLogin(String username, String password) async {
    final http.Response response = await http.post(
      'http://10.0.2.2:8181/api/Members/SignIn',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'SignInKey': username,
        'Password': password,
      }),
    );
    print(response.statusCode);
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _loginResult,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                Future.delayed(Duration.zero, () async {
                  Navigator.of(context).push(routeUpToBottom(MyFields()));
                });
              } else {
                return Stack(
                  children: <Widget>[
                    _getVideoBackground(),
                    _getBackgroundColor(),
                    _getContent(true),
                  ],
                );
              }
            } else {
              return Stack(
                children: <Widget>[
                  _getVideoBackground(),
                  _getBackgroundColor(),
                  _getContent(false),
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
