import 'package:avis_manga/models/manga.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/views/partials/components/chapter.dart';

class ChaptersList extends StatelessWidget {
  final MangaMetadata manga;

  ChaptersList(this.manga);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(manga.title),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: manga.chapters.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.all(10.0),
              child: Chapter(manga, manga.chapters[index], color: Colors.black)
            );
          },
        ),
      ),
    );
  }
}