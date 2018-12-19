import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String mangaCollection = "Manga";
const String userCollection = "User";

class Database {
  static final Database _instance = new Database._internal();

  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Firestore _db = Firestore.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static get instance => _instance;

  Database._internal();

  // Authentification

  Future<User> _queryUser(FirebaseUser user) {
    DocumentReference doc = _db.collection(userCollection).document(user.uid);
    return doc.get().then((userDoc) {
      if (userDoc.exists) {
        return User.fromMap(userDoc.data);
      }
      return doc.setData({"uid": user.uid}).then((_) => User(user.uid));
    });
  }

  Future<User> emailSignUp(String email, String password) async {
    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) => _queryUser(user));
  }

  Future<User> googleSignIn() async {
    return _googleSignIn.signIn().then((user) {
      return user.authentication.then((auth) {
        return _auth
            .signInWithGoogle(
              accessToken: auth.accessToken,
              idToken: auth.idToken,
            )
            .then((user) => _queryUser(user));
      });
    });
  }

  Future<User> emailSignIn(String email, String password) async {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) => _queryUser(user));
  }

  Future<void> signOut() async {
    return _auth.signOut();
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
