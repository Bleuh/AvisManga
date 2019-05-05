import 'package:avis_manga/auth.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/views/viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MangaPage extends StatefulWidget {
  MangaMetadata manga;

  MangaPage({Key key, @required this.manga}) : super(key: key);

  @override
  _MangaPageState createState() => new _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool titleScrolled = false;
  double bgHeight = 150.0;
  double headOpacity = 0.0;
  ScrollController controller;
  List<MangaChapter> chapters = [];
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Stack(children: <Widget>[
          ListView(controller: controller, children: <Widget>[
            Container(
              height: bgHeight,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: widget.manga.mainImage,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.error)),
                      fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            stops: [0.0, 1.0],
                            colors: [Colors.black45, Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  )
                ],
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -30.0, 0.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 5.0),
                        ),
                        height: 200.0,
                        width: 140.0,
                        child: CachedNetworkImage(
                            imageUrl: widget.manga.coverImage,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          this.titleScrolled ? '' : this.widget.manga.title,
                          style: Theme.of(context).primaryTextTheme.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              "Par ${widget.manga.author['last_name']} ${widget.manga.author['first_name']}",
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle),
                          Text(widget.manga.status.toString(),
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle)
                        ],
                      )
                    ]),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new ViewerPage(this.widget.manga)));
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.play_arrow,
                                      size: 40.0, color: Colors.white),
                                  Text(
                                    "Reprendre",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .button,
                                  )
                                ],
                              )),
                          flex: 1,
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.list,
                                    size: 40.0, color: Colors.white),
                                Text(
                                  "${widget.manga.nbChap.toString()} Chapitres",
                                  style:
                                      Theme.of(context).primaryTextTheme.button,
                                )
                              ],
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                Auth.instance.then((auth) {
                                  var user = auth.currentUser;
                                  var newFav =
                                      new List<String>.from(user.favorites);
                                  if (isFav) {
                                    newFav.remove(widget.manga.id);
                                  } else {
                                    newFav.add(widget.manga.id);
                                  }
                                  user.favorites = newFav;
                                  setState(() {
                                    isFav = !isFav;
                                  });
                                  Auth.db.updateUser(user).then((_) =>
                                      _showSnackBar(isFav
                                          ? 'Favorie ajouter'
                                          : 'Favorie retirer'));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30.0,
                                      color: Colors.white),
                                  Text(
                                    isFav ? "- Favoris" : "+ Favoris",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .button,
                                  )
                                ],
                              )),
                          flex: 1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorDark),
              height: 16.0,
            ),
            Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Genre",
                      style: Theme.of(context).primaryTextTheme.headline,
                    ),
                  ),
                  Container(
                    height: 35.0,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.manga.tags.map((name) {
                          return Container(
                            child: Chip(
                              backgroundColor:
                                  Theme.of(context).primaryColorDark,
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              label: Text(name),
                            ),
                            padding: EdgeInsets.only(right: 10.0),
                          );
                        }).toList()),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: Theme.of(context).primaryTextTheme.headline,
                    ),
                  ),
                  Container(
                    child: Text(
                      widget.manga.description,
                      style: Theme.of(context).primaryTextTheme.body1,
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorDark),
              height: 16.0,
            ),
            Container(
              padding: EdgeInsets.all(30.0),
              child: Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Chapitres",
                    style: Theme.of(context).primaryTextTheme.headline,
                  ),
                ),
                Column(
                    children: widget.manga.chapters
                        .map((chapter) => Card(child: Text(chapter.url)))
                        .toList())
              ]),
            )
          ]),
          Positioned(
            width: MediaQuery.of(context).size.width,
            height: 80.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  opacity: headOpacity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 2.0))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 5.0 + MediaQuery.of(context).padding.top,
                      bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back,
                                size: 40.0, color: Colors.white)),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            titleScrolled ? this.widget.manga.title : '',
                            style: Theme.of(context).primaryTextTheme.title,
                          ),
                        ),
                        flex: 3,
                      ),
                      Expanded(
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.share,
                                size: 30.0, color: Colors.white)),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onScroll);
  }

  @override
  void initState() {
    super.initState();
    Auth.instance.then((Auth auth) {
      isFav = auth.currentUser.favorites.contains(widget.manga.id);
    });
    chapters = widget.manga.chapters;
    controller = ScrollController();
    controller.addListener(onScroll);

    if (chapters.isEmpty) {
      _loadChapters();
    }
  }

  onScroll() {
    setState(() {
      titleScrolled = controller.offset >
          (bgHeight - MediaQuery.of(context).padding.top + 155.0);
      headOpacity = titleScrolled ? 1.0 : 0.0;
    });
  }

  Future _loadChapters() async =>
      Database.instance.getChapters(widget.manga).then((manga) => setState(() {
            widget.manga = manga;
            chapters = widget.manga.chapters;
          }));

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
}
