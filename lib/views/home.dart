import 'package:avis_manga/auth.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/views/partials/previews/manga_card.dart';
import 'package:avis_manga/views/partials/previews/favorite_card.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/views/partials/feed.dart';
import 'package:avis_manga/views/partials/favorites.dart';
import 'package:avis_manga/views/partials/home_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.data}) : super(key: key);

  final String title = 'AvisManga';
  final List<MangaMetadata> data;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children;
  List<PopupMenuItem<String>> _options;

  bool friendFilter = false;

  AuthListener _listener;

  User user;

  @override
  void initState() {
    super.initState();
    var widgets = this.widget.data.map((meta) {
      return MangaCard(meta);
    }).toList();

    var widgetsFavorites = this.widget.data.map((meta) {
      return FavoriteCard(meta);
    }).toList();

    _options = [
      new PopupMenuItem<String> (
        value: 'friend_only',
        child: new SwitchListTile(
            value: friendFilter,
            onChanged: (_) => print('change'),
            title: new Text('View only friends'),
        )
      )
    ];

    _children = [
      Feed(widgets),
      Favorites(widgetsFavorites),
      Feed(widgets) // waiting other page
    ];
  }

  _HomePageState() {
    _listener = new AuthListener(onLogout: onLogout);
    Auth.instance.then((auth) {
      auth.subscribe(_listener);
      setState(() {
        user = auth.currentUser;
      });
    });
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
          title: new Text(widget.title),
          actions: <Widget>[
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return _options;
              },
            )
          ],
        ),
        drawer: HomeDrawer(this.user),
        body: _children[_currentIndex],
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
              icon: Icon(Icons.person_pin),
              title: Text('Friends')
            )
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
