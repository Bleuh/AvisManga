import 'package:avis_manga/auth.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/models/comment.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/views/viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:avis_manga/views/partials/components/comment_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  double _animatedHeightCommentary = 279.0;
  double _animatedHeightChapters = 279.0;

  bool ownManga = false;

  @override
  void initState() {
    super.initState();
    Auth.instance.then((Auth auth) {
      isFav = auth.currentUser.favorites.contains(widget.manga.id);
      ownManga = auth.currentUser.ownManga.contains(widget.manga.id);
    });
    chapters = widget.manga.chapters;
    controller = ScrollController();
    controller.addListener(onScroll);

    if (chapters.isEmpty) {
      _loadChapters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _asyncInputDialog(context).then((newComment) {
            if (newComment != null) {
              Auth.instance.then((auth) {
                Database.instance
                    .insertComment(widget.manga, auth.currentUser, newComment)
                    .then((comment) {
                  widget.manga.comments.add(comment);
                  auth.currentUser.comments.add(comment);
                  Database.instance.updateUser(auth.currentUser);
                  widget.manga.comments.sort((Comment a, Comment b) {
                    return -a.score.compareTo(b.score);
                  });
                  _showSnackBar('Commentaire ajouté !');
                });
              });
            }
          });
        },
        tooltip: 'AddCom',
        child: new Icon(Icons.add_comment),
        heroTag: "AddCom",
      ),
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
                              "Par ${widget.manga.author.lastName} ${widget.manga.author.firstName}",
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle),
                          Text(widget.manga.statusString(),
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
                          child: buildRestartButton(context),
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
                                  Auth.db.updateUser(user).then((_) {
                                    auth.setUser(user);
                                    _showSnackBar(isFav
                                        ? 'Favorie ajouter'
                                        : 'Favorie retirer');
                                  });
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 40.0,
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
                  widget.manga.images.where((image) => image != '').isNotEmpty
                      ? Container(
                          height: 200.0,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: widget.manga.images.map((image) {
                                return Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  child: CachedNetworkImage(
                                      imageUrl: image,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Center(child: Icon(Icons.error)),
                                      fit: BoxFit.cover),
                                );
                              }).toList()),
                        )
                      : Container(),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
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
                padding: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0),
                    alignment: Alignment.center,
                    child: Text(
                      widget.manga.comments.length.toString() + " commentaires",
                      style: Theme.of(context).primaryTextTheme.headline,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.bounceIn,
                    height: _animatedHeightCommentary,
                    child: Wrap(
                        children: widget.manga.comments.map((comment) {
                      return CommentRow(comment, textColor: Colors.white);
                    }).toList()),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                          _animatedHeightCommentary != null
                              ? _animatedHeightCommentary = null
                              : _animatedHeightCommentary = 279.0;
                        }),
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      child: new Text(
                          _animatedHeightCommentary != null
                              ? "Voir plus de commentaires"
                              : "Voir moins de commentaires",
                          style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColorDark,
                      height: 25.0,
                      width: 200.0,
                    ),
                  ),
                ])),
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
                  alignment: Alignment.center,
                  child: Text(
                    "${widget.manga.nbChap.toString()} chapitres",
                    style: Theme.of(context).primaryTextTheme.headline,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.bounceIn,
                  height: _animatedHeightChapters,
                  child: Wrap(
                      children: widget.manga.chapters
                          .map((chapter) => Card(child: Text(chapter.key)))
                          .toList()),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                        _animatedHeightChapters != null
                            ? _animatedHeightChapters = null
                            : _animatedHeightChapters = 279.0;
                      }),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: new Text(
                        _animatedHeightChapters != null
                            ? "Voir plus de chapitres"
                            : "Voir moins de chapitres",
                        style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColorDark,
                    height: 25.0,
                    width: 200.0,
                  ),
                ),
              ]),
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
                    alignment: Alignment.center,
                    child: Text(
                      "Auteur : ${widget.manga.author.lastName} ${widget.manga.author.firstName}",
                      style: Theme.of(context).primaryTextTheme.headline,
                    ),
                  ),
                  Container(
                    height: 150.0,
                    width: 150.0,
                    margin: EdgeInsets.all(12.0),
                    child: Stack(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: new BoxConstraints.expand(),
                          child: ClipOval(
                            child: Image(
                                image: CachedNetworkImageProvider(
                                    widget.manga.author.image),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "né le : ${DateFormat('dd/MM/yyyy').format(widget.manga.author.birthDay)} à ${widget.manga.author.birthPlace}",
                      style: Theme.of(context).primaryTextTheme.body1,
                    ),
                  ),
                  Text(
                    widget.manga.author.biography,
                    style: Theme.of(context).primaryTextTheme.body1,
                  ),
                ]))
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

  FlatButton buildRestartButton(BuildContext context) {
    return this.ownManga
        ? FlatButton(
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new ViewerPage(this.widget.manga)));
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.play_arrow, size: 40.0, color: Colors.white),
                Text(
                  "Reprendre",
                  style: Theme.of(context).primaryTextTheme.button,
                )
              ],
            ))
        : FlatButton(
            onPressed: () {
              _asyncBuyDialog(context).then((bool action) {
                if (action != null && action != false) {
                  Auth.instance.then((auth) {
                    User user = auth.currentUser;
                    if (user.wallet >= 10) {
                      user.wallet -= 10;
                      var newOwn = new List<String>.from(user.ownManga);
                      newOwn.add(widget.manga.id);
                      user.ownManga = newOwn;
                      Database.instance.updateUser(user).then((_) {
                        auth.setUser(user);
                        setState(() {
                          ownManga = true;
                        });
                        _showSnackBar('Manga acheté avec succes !');
                      });
                    } else {
                      _showSnackBar('Vous n\'avez pas assez de ¥');
                    }
                  });
                }
              });
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.lock, size: 40.0, color: Colors.white),
                Text(
                  "Acheter (10¥)",
                  style: Theme.of(context).primaryTextTheme.button,
                )
              ],
            ));
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String comment = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${widget.manga.title}'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Votre commentaire',
                    hintText: 'Manga très intéressant'),
                onChanged: (value) {
                  comment = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ajouter'),
              onPressed: () {
                Navigator.of(context).pop(comment);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _asyncBuyDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Acheter ${widget.manga.title} d\'une valeur de 10¥ ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Accepter'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onScroll);
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
