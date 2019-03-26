import 'dart:ui';

import 'package:avis_manga/auth.dart';
import 'package:avis_manga/data/error.dart';
import 'package:avis_manga/models/user.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<LoginPage> {
  final signupFormKey = new GlobalKey<FormState>();
  final loginFormKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _emailController = new TextEditingController(text: "testtest@test.com");
  final _passwordController = new TextEditingController(text: "testtest");

  AuthListener _listener;

  _LoginState() {
    _listener = new AuthListener(onLoginSuccess: onLoginSuccess, onLoginError: onLoginError);
    Auth.instance.then((Auth auth) {
      auth.subscribe(_listener);
    });
  }

  gotoLogin() {
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
  }

  gotoSignup() {
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  Widget buildSignupButton() {
    return new OutlineButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      color: Theme.of(context).primaryColor,
      highlightedBorderColor: Colors.white,
      onPressed: () => gotoSignup(),
      child: new Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: Text(
                "SIGN UP",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return new FlatButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      color: Colors.white,
      onPressed: () => gotoLogin(),
      child: new Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: Text(
                "LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHomePage() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage('assets/images/bg-manga-home.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 150.0),
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 150.0,
                height: 150.0
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Avis Manga",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 100.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                Expanded(child: buildSignupButton()),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: buildLoginButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextRow(String text) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: new Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmailInput() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 0.5,
              style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: _emailController,
              validator: (val) {
                return val.length < 10
                    ? "Username must have atleast 10 chars"
                    : null;
              },
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'testtest@test.com',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPasswordInput() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 0.5,
              style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '*********',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConfirmPasswordInput() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 0.5,
              style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              validator: (input) {
                return (input != _passwordController.text)
                    ? "passwords are different"
                    : null;
              },
              obscureText: true,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '*********',
                hintStyle: TextStyle(color: Colors.grey),
                errorMaxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExternalConnect(IconData icon, String text, Color color, VoidCallback onPressed) {
    return new Expanded(
      child: new Container(
        margin: EdgeInsets.only(right: 8.0),
        alignment: Alignment.center,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: color,
                onPressed: onPressed,
                child: new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: new FlatButton(
                          onPressed: onPressed,
                          padding: EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 15.0,
                                )
                              ),
                              Text(
                                text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmButton(String text, VoidCallback onPressed, {double top: 0.0}) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: top),
      alignment: Alignment.center,
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: onPressed,
              child: new Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLoginPage() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(0.1), BlendMode.dstATop
          ),
          image: AssetImage('assets/images/bg-manga-home.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Form(
        key: loginFormKey,
        child: new ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 150.0,
                  height: 150.0
                ),
              ),
            ),
            buildTextRow("EMAIL"),
            buildEmailInput(),
            Divider(
              height: 24.0,
            ),
            buildTextRow("PASSWORD"),
            buildPasswordInput(),
            Divider(
              height: 24.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: new FlatButton(
                    child: new Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () => {},
                  ),
                ),
              ],
            ),
            buildConfirmButton("LOGIN", () {
              if (loginFormKey.currentState.validate()) {
                Auth.instance.then((auth) {
                  auth.doLogin(
                    _emailController.text, _passwordController.text
                  );
                });
              }
            }, top: 0.0),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.all(8.0),
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.25)),
                    ),
                  ),
                  Text(
                    "OR CONNECT WITH",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.all(8.0),
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.25)),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.only(left: 8.0),
                      alignment: Alignment.center,
                      child: new Row(
                        children: <Widget>[
                          buildExternalConnect(
                              const IconData(0xea88, fontFamily: 'icomoon'),
                              "GOOGLE",
                              Color(0Xffdb3236), () {
                            Auth.instance.then((Auth auth) {
                              auth.doGoogleLogin();
                            });
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )));
  }

  Widget buildSignupPage() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('assets/images/bg-manga-home.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Form(
        key: signupFormKey,
        child: new ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 150.0,
                  height: 150.0
                ),
              ),
            ),
            buildTextRow("EMAIL"),
            buildEmailInput(),
            Divider(
              height: 24.0,
            ),
            buildTextRow("PASSWORD"),
            buildPasswordInput(),
            Divider(
              height: 24.0,
            ),
            buildTextRow("CONFIRM PASSWORD"),
            buildConfirmPasswordInput(),
            Divider(
              height: 24.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: new FlatButton(
                    child: new Text(
                      "Already have an account ?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () async {
                      print("Pressed");
                      await _controller.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                      print("Scrolled");
                    },
                  ),
                ),
              ],
            ),
            buildConfirmButton("SIGN UP", () {
              if (signupFormKey.currentState.validate()) {
                Auth.instance.then((auth) {
                  auth.doSignUp(
                      _emailController.text, _passwordController.text);
                });
              }
            }, top: 0.0)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              buildLoginPage(),
              buildHomePage(),
              buildSignupPage()
            ],
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void onLoginError(LoginError error) {
    _showSnackBar(error.toString());
  }
  void onLoginSuccess(User user) {
    Navigator.of(context).pushNamed("/");
  }

  @override
  void dispose() {
    super.dispose();
    Auth.instance.then((auth) => auth.dispose(_listener));
  }
}
