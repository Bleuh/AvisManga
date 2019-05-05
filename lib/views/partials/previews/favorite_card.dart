import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/views/manga.dart';

class FavoriteCard extends StatelessWidget {
  final MangaMetadata meta;

  FavoriteCard(this.meta);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
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
        child: CachedNetworkImage(
          imageUrl: this.meta.coverImage,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
          fit: BoxFit.cover,
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
