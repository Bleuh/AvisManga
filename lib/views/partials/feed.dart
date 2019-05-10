import 'package:flutter/material.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/views/partials/previews/manga_card.dart';

class Feed extends StatelessWidget {
  final List<MangaMetadata> mangas;

  Feed(this.mangas);

  List<MangaCard> buildMangaCard() {
    return this.mangas.map((manga) {
      return MangaCard(manga);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: buildMangaCard(),
      ),
    );
  }
}