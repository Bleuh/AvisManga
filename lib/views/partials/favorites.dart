import 'package:flutter/material.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/views/partials/previews/favorite_card.dart';

class Favorites extends StatelessWidget {
  final List<MangaMetadata> mangas;
  final bool display;

  Favorites(this.mangas, this.display);

  List<FavoriteCard> buildFavoritesCard() {
    return this.mangas.map((manga) {
      return FavoriteCard(manga, small: display);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(10.0),
      children: buildFavoritesCard(),
      childAspectRatio: 8/15,
      crossAxisCount: display ? 3 : 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
    );
  }
}