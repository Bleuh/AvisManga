import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/views/manga.dart';

class FavoriteCard extends StatelessWidget {
  final MangaMetadata meta;
  final bool small;
  final double textHeight = 56.0;

  FavoriteCard(this.meta, {this.small = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: small ? 199.0 : 308.3,
        width: (small ? 199.0 : 308.3) * 8/15,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(
                0.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: (small ? 199.0 : 308.3) - textHeight,
              width: (small ? 199.0 : 308.3) - textHeight * 8/15,
              child: CachedNetworkImage(
                imageUrl: this.meta.coverImage,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              alignment: Alignment.center,
              height: textHeight,
              child: Text(
                this.meta.title,
                style: Theme.of(context).primaryTextTheme.subtitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new MangaPage(manga: this.meta)
          )
        );
      },
    );
  }
}
