import 'package:flutter/material.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MangaPage extends StatefulWidget {
  MangaPage({Key key, @required this.manga}) : super(key: key);

  final String title = 'AvisManga';
  final MangaMetadata manga;


  @override
  _MangaPageState createState() => new _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {

  bool titleScrolled = false;
  double bgHeight = 150.0;
  double headOpacity = 0.0;
  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(onScroll);
    super.initState();
  }

  onScroll() {
    setState(() {
      titleScrolled = controller.offset > (bgHeight - MediaQuery.of(context).padding.top + 155.0);
      headOpacity = titleScrolled ? 1.0 : 0.0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children:<Widget>[
          ListView(
            controller: controller,
            children: <Widget>[
              Container(
                height: bgHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: widget.manga.mainImage,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      fit: BoxFit.cover
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.0, 1.0],
                          colors: [
                            Colors.black45,
                            Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                        )
                      ),
                    )
                  ],
                ),
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 5.0
                            ),
                          ),
                          height: 200.0,
                          width: 140.0,
                          child: CachedNetworkImage(
                            imageUrl: widget.manga.coverImage,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                            fit: BoxFit.cover
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
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
                                widget.manga.author['first_name'],
                                style: Theme.of(context).primaryTextTheme.subtitle
                              ),
                              Text(
                                widget.manga.status.toString(),
                                style: Theme.of(context).primaryTextTheme.subtitle
                              )
                            ],
                          )
                        ]
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.play_arrow, size: 40.0, color: Colors.white),
                                  Text("Reprendre", style: Theme.of(context).primaryTextTheme.button,)
                                ],
                              )
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.list, size: 40.0, color: Colors.white),
                                  Text(widget.manga.nbChap.toString() + " Chapitres", style: Theme.of(context).primaryTextTheme.button,)
                                ],
                              ),

                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.favorite, size: 30.0, color: Colors.white),
                                  Text("Ajouter aux favoris", style: Theme.of(context).primaryTextTheme.button,)
                                ],
                              )
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor
                ),
                height: 16.0,
              ),
              Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.manga.description,
                      style: Theme.of(context).primaryTextTheme.body1,
                    )
                  ],
                ),
              ),
              Container(
                height: 500.0,
              )
            ]
          ),
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
                          width: 2.0
                        )
                      )
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 5.0 + MediaQuery.of(context).padding.top,
                    bottom: 5.0
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back, size: 40.0, color: Colors.white)
                        ),
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
                          child: Icon(Icons.share, size: 30.0, color: Colors.white)
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]
      ),
    );
  }

}