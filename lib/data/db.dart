import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avis_manga/models/manga.dart';

const String mangaCollection = "Manga";

class Database {
  static final Database _instance = new Database._internal();

  static Firestore db = Firestore.instance;

  static get instance => _instance;

  Database._internal();

  Future<List<MangaMetadata>> listMangas() async {
    return db.collection(mangaCollection).getDocuments().then((query) {
      return query.documents.map((doc) {
        return MangaMetadata.fromMap(doc.data);
      }).toList();
    });
  }

  Future<MangaMetadata> getManga(String title) async {
    return db.collection(mangaCollection).document(title).get().then((doc) {
      if (!doc.exists) {
        return Future.error("missing data");
      }
      return MangaMetadata.fromMap(doc.data);
    });
  }

  Future<void> insertManga(MangaMetadata manga) async {
    return db
        .collection(mangaCollection)
        .document(manga.title)
        .setData(manga.toMap());
  }

  Future<void> deleteManga(String title) async {
    return db.collection(mangaCollection).document(title).delete();
  }
}
