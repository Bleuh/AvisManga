import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/views/manga.dart';
import 'package:avis_manga/views/partials/icon_star.dart';
import 'package:avis_manga/views/partials/components/comment_row.dart';

class MangaCard extends StatelessWidget {
  final MangaMetadata meta;

  MangaCard(this.meta);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Row(
              children: <Widget>[
                Container(
                  child: CachedNetworkImage(
                    imageUrl: this.meta.coverImage,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                    fit: BoxFit.cover,
                  ),
                  height: 200.0,
                  width: 140.0,
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
                            "${this.meta.nbChap.toString()} chapitres - ${this.meta.statusString()}",
                            textAlign: TextAlign.left,
                          ),
                          padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                        ),
                        Row(
                          children: [0, 1, 2, 3, 4].map((index) {
                            return IconStar(
                                color: Colors.black,
                                index: index,
                                rating: this.meta.rating
                            );
                          }).toList()
                        ),
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
                              maxLines: 5,
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
                ),
              ],
            ),
            onTap: () {
              Navigator.push(context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => new MangaPage(manga: this.meta)
                )
              );
            },
          ),
          ExpansionTile(
            title: Row(
              children: <Widget>[
                  Text(meta.comments.length.toString() + ' commentaires...'),
              ] + meta.comments.take(3).map((comment) {
                return Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: ClipOval(
                    child: Image(
                      height: 25.0,
                      width: 25.0,
                      image: CachedNetworkImageProvider(comment.user.avatar),
                      fit: BoxFit.cover
                    ),
                  ),
                );
              }).toList(),
            ),
            children: meta.comments.take(3).map((comment) {
              return CommentRow(comment);
            }).toList()
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}
