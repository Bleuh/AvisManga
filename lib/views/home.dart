import 'package:avis_manga/auth.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/data/error.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/views/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avis_manga/views/partials/manga_card.dart';
import 'package:avis_manga/models/manga.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.data}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'homepage';
  final Map<String, dynamic> data;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> implements AuthListener {
  _HomePageState() {
    Auth.instance.then((auth) => auth.subscribe(this));
  }

  @override
  Widget build(BuildContext context) {
    var widgets = this.widget.data.values.map((meta) {
      return MangaCard(meta);
    }).toList();
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the HomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Auth.instance.then((a) => a.doLogout());
              },
            )
          ],
        ),
        body: new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widgets,
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () => print("Pressed"),
          tooltip: 'Search',
          child: new Icon(Icons.search),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  @override
  void onLoginError(LoginError error) {
    // We assume we are already logged in
  }

  @override
  void onLoginSuccess(User user) {
    // We assume we are already logged in
  }

  @override
  void onLogout() {
    bool hasLogin = false;
    Navigator.of(context).popUntil((route) {
      if (route.settings.name == "/login") {
        hasLogin = true;
        return true;
      }
      if (route.isFirst) {
        return true;
      }
      return false;
    });
    if (!hasLogin) {
      Navigator.of(context).pushReplacementNamed("/login");
    }
    Auth.instance.then((auth) => auth.dispose(this));
  }
}
