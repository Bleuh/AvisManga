import 'package:avis_manga/auth.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/views/partials/feed.dart';
import 'package:avis_manga/views/partials/favorites.dart';
import 'package:avis_manga/views/partials/friends_list.dart';
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

  List<Widget> popupmenuHome;
  List<Widget> popupmenuFav;

  List<Widget> popupmenu;

  bool friendFilter = false;
  bool display = false;

  AuthListener _listener;

  User user;

  @override
  void initState() {
    super.initState();

    popupmenuHome = <Widget>[];
    // popupmenuHome = PopupMenuButton<String>(
    //   itemBuilder: (BuildContext context) {
    //     return [
    //       new PopupMenuItem<String> (
    //         value: 'friend_only',
    //         child: new SwitchListTile(
    //           value: friendFilter,
    //           onChanged: (value) => setState((){friendFilter = value;}),
    //           title: new Text('View only friends'),
    //         )
    //       ),
    //     ];
    //   },
    // );

    popupmenuFav = <Widget>[
      IconButton(
        icon: Icon(Icons.photo_size_select_large),
        onPressed: () {
          Favorites fav = _children[1];
          _children.insert(1, Favorites(fav.mangas, !display));
          setState((){
            _children = _children;
            display = !display;
          });
        },
      ),
    ];

    popupmenu = popupmenuHome;

    _children = [];
  }

  _HomePageState() {
    _listener = new AuthListener(onLogout: onLogout);
    Auth.instance.then((auth) {
      auth.subscribe(_listener);
      setState(() {
        user = auth.currentUser;
        _children = [
          Feed(this.widget.data, auth.currentUser),
          Favorites([], display),
          FriendsList(auth.currentUser.friends) // waiting other page
        ];
      });
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          Database.instance.listMangas().then((List<MangaMetadata>data) {
            _children.insert(0, Feed(data, this.user));
            setState(() {
              _children = _children;
            });
          });
          popupmenu = popupmenuHome;
          break;
        case 1:
          Database.instance.listMangas(ids: user.favorites).then((List<MangaMetadata> data) {
            _children.insert(1, Favorites(data, display));
            setState(() {
              _children = _children;
            });
          });
          popupmenu = popupmenuFav;
          break;
        default:
          setState(() {
            _children[2] = FriendsList(user.friends);
          });
         popupmenu = <Widget>[];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: popupmenu,
        ),
        drawer: HomeDrawer(this.user),
        body: _children.isNotEmpty ? _children[_currentIndex] : Container(),
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
