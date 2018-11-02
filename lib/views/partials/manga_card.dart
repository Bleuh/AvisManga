import 'package:flutter/material.dart';
import 'package:avis_manga/data/manga.dart';
import 'package:avis_manga/views/partials/icon_star.dart';

class MangaCard extends StatelessWidget {
  final MangaMetadata meta;

  MangaCard(this.meta);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Image.network(
                  this.meta.mainImage,
                ),
                constraints: BoxConstraints(maxHeight: 200.0, maxWidth: 200.0),
                padding: EdgeInsets.all(5.0),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          this.meta.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                        padding: EdgeInsets.only(left:5.0, top:5.0, bottom: 2.0),
                        alignment: Alignment.bottomLeft,
                      ),
                      Container(
                        child: Text(
                          this.meta.nbChap.toString() + " chapitres",
                          textAlign: TextAlign.left,
                        ),
                        padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                      ),
                      Row(
                          children: [0, 1, 2, 3, 4].map((index) {
                        return IconStar(
                            color: Colors.black,
                            index: index,
                            rating: this.meta.rating);
                      }).toList()),
                      Container(
                        height: 35.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                            children: this.meta.tags.map((name) {
                          return Container(
                            child: Chip(
                              label: Text(name),
                            ),
                            padding: EdgeInsets.only(right: 10.0),
                          );
                        }).toList()),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            this.meta.description,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            maxLines: 3,
                          ),
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  height: 200.0,
                  padding: EdgeInsets.all(5.0),
                  alignment: Alignment.topLeft,
                ),
              )
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      margin: EdgeInsets.all(10.0),
    );
  }
}
