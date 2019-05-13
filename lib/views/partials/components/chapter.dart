import 'package:flutter/material.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/views/viewer.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/auth.dart';

class Chapter extends StatelessWidget {
  final MangaMetadata manga;
  final MangaChapter chapter;
  final Color color;

  Chapter(this.manga, this.chapter, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        chapter.key,
        style: TextStyle(
          color: color,
        ),
      ),
      onPressed: () {
        Auth.instance.then((auth){
          auth.currentUser.lastMangaRead = this.manga.title;
          auth.currentUser.lastTimeRead = null;
          Database.instance.updateUser(auth.currentUser).then((_){
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new ViewerPage(manga,
                            chapter.number - 1)));
          });
        });
      },
    );
  }
}