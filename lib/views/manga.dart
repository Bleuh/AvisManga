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
  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(onScroll);
    super.initState();
  }

  onScroll() {
    setState(() {
      titleScrolled = controller.offset > (bgHeight - MediaQuery.of(context).padding.top + 15.0);
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
                child: Text(
                  this.titleScrolled ? '' : this.widget.manga.title,
                  style: Theme.of(context).primaryTextTheme.title,
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0
                ),
              ),
              Container(
                height: 1100.0,
              )
            ]
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
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
          )
        ]
      ),
    );
  }

}