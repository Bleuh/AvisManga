import 'package:flutter/material.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/views/partials/previews/manga_card.dart';
import 'package:avis_manga/views/partials/previews/favorite_card.dart';

class Feed extends StatelessWidget {
  final List<MangaMetadata> mangas;
  final User user;

  Feed(this.mangas, this.user);

  Widget buildMangaCard(BuildContext context, List<MangaMetadata> mangas, {String title = ''}) {
    int counter = 0;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget> [
            title.isNotEmpty ? Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(title, style: Theme.of(context).textTheme.title, textAlign: TextAlign.left,)
            ) : Container(),
        ] + mangas.map((manga) {
          counter += 1;
          return Padding(
            padding: counter == mangas.length ? EdgeInsets.all(0.0) : EdgeInsets.only(bottom: 10.0),
            child: MangaCard(manga)
          );
        }).toList()
      ),
    );
  }

  Widget buildMangaCardHorizontal(BuildContext context, List<MangaMetadata> mangas, {String title = ''}) {
    int counter = 0;
    return Container(
      height: 233.0,
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          title.isNotEmpty ? Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(title, style: Theme.of(context).textTheme.title, textAlign: TextAlign.left,)
          ) : Container(),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: mangas.map((manga) {
                counter += 1;
                return Padding(
                  padding: counter == mangas.length ? EdgeInsets.all(0.0) : EdgeInsets.only(right: 10.0),
                  child: FavoriteCard(manga, small: true),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  FutureBuilder buildRelatedMangaCard(List<dynamic> favorites){
    return FutureBuilder(
      future: Database.instance.listMangas(ids: favorites),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          List<MangaMetadata> results = snapshot.data;
          List<MangaMetadata> relatedMangas = this.mangas.where((m) => m.tags.contains(results.first.tags.first)).where((m) => m.title != results.first.title).toList();
          return relatedMangas.isNotEmpty ? buildMangaCard(context, relatedMangas, title: 'Parce que vous aimez ${results.first.title}') : Container();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        buildMangaCard(context, [this.mangas.first], title: 'Nouveautée de la semaine'),
        buildMangaCardHorizontal(context, this.mangas.where((m) => m.tags.contains('Aventure')).toList(), title: 'Le meilleur de l\'aventure'),
        user.favorites.isNotEmpty ? buildRelatedMangaCard(user.favorites) : Container(),
        buildMangaCardHorizontal(context, this.mangas.where((m) => m.tags.contains('Horreur')).toList(), title: 'Se faire peur avant de dormir'),
        buildMangaCard(context, this.mangas, title: 'Mangas de la semaine'),
      ],
    );
  }
}