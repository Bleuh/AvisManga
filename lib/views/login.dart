import 'dart:ui';

import 'package:avis_manga/models/user.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/auth.dart';

import 'package:avis_manga/views/loading.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<LoginPage> implements AuthListener {

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;

  _LoginState() {
    Auth.instance.then((Auth auth) {
      auth.subscribe(this);
    });
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      Auth.instance.then((Auth auth) {
        auth.doLogin(_username, _password);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Colors.primaries[0],
    );
    var loginForm = new Column(
      children: <Widget>[
        new Text(
          "Login App",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  initialValue: "testtest@test.com",
                  validator: (val) {
                    return val.length < 10
                        ? "Username must have atleast 10 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  initialValue: "testtest",
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              child: new Container(
                child: loginForm,
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void onLoginError(String error) {
    _showSnackBar(error);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      settings: const RouteSettings(name: '/'),
      builder: (context) => new LoadingPage(),
    ));
  }
}