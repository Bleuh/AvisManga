import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String mangaCollection = "Manga";

class Database {
  static final Database _instance = new Database._internal();

  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Firestore _db = Firestore.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static get instance => _instance;

  Database._internal();

  // Authentification

  Future<FirebaseUser> googleSignIn() async {
    return _googleSignIn.signIn().then((user) {
      return user.authentication.then((auth) {
        return _auth.signInWithGoogle(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );
      });
    });
  }

  Future<FirebaseUser> emailSignIn(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Manga

  Future<List<MangaMetadata>> listMangas() async {
    return _db.collection(mangaCollection).getDocuments().then((query) {
      return query.documents.map((doc) {
        return MangaMetadata.fromMap(doc.data);
      }).toList();
    });
  }

  Future<MangaMetadata> getManga(String title) async {
    return _db.collection(mangaCollection).document(title).get().then((doc) {
      if (!doc.exists) {
        return Future.error("missing data");
      }
      return MangaMetadata.fromMap(doc.data);
    });
  }

  Future<void> insertManga(MangaMetadata manga) async {
    return _db
        .collection(mangaCollection)
        .document(manga.title)
        .setData(manga.toMap());
  }

  Future<void> deleteManga(String title) async {
    return _db.collection(mangaCollection).document(title).delete();
  }
}
