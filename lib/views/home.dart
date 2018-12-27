import 'package:avis_manga/auth.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/data/error.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/views/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avis_manga/views/partials/manga_card.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/views/partials/feed.dart';

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

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children;

  AuthListener _listener;

  @override
  void initState() {
    super.initState();
    // var widgets = this.widget.data.values.map((meta) {
    //   return MangaCard(meta);
    // }).toList();

    // _children = [
    //   Feed(widgets),
    //   Feed(widgets), // waiting other page
    //   Feed(widgets) // waiting other page
    // ];
    _children = [
      Text('Index 0: Home'),
      Text('Index 1: Business'),
      Text('Index 2: School'),
    ];
  }

  _HomePageState() {
    _listener = new AuthListener(onLogout: onLogout);
    Auth.instance.then((auth) => auth.subscribe(_listener));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: _children.elementAt(_currentIndex),
        floatingActionButton: new FloatingActionButton(
          onPressed: () => print("Pressed"),
          tooltip: 'Search',
          child: new Icon(Icons.search),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorites'),
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.person_pin), title: Text('Friends'))
          ],
        ),
      ),
    );
  }

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
    Auth.instance.then((auth) => auth.dispose(_listener));
  }

  @override
  void dispose() {
    super.dispose();
    Auth.instance.then((auth) => auth.dispose(_listener));
  }
}
