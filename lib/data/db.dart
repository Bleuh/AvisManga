import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avis_manga/models/manga.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/models/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String mangaCollection = "Manga";
const String chaptersCollection = "chapters";
const String commentsCollection = "comments";

const String userCollection = "User";

class Database {
  static final Database _instance = new Database._internal();

  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Firestore _db = Firestore.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static Database get instance => _instance;

  Database._internal();

  // Authentification

  Future<User> currentUser() {
    return _auth.currentUser().then(_queryUser);
  }

  Future<void> updateUser(User user) {
    DocumentReference doc = _db.collection(userCollection).document(user.uid);
    return doc.updateData({
      'avatar': user.avatar,
      'email': user.email,
      'name': user.name,
      'wallet': user.wallet,
      'favorites': user.favorites
    });
  }

  Future<User> _queryUser(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    DocumentReference doc = _db.collection(userCollection).document(user.uid);
    return doc.get().then((userDoc) {
      if (userDoc.exists) {
        return User.fromMap(userDoc.data);
      }
      return doc.setData({
        "uid": user.uid,
        "avatar": user.photoUrl,
        "name": user.displayName,
        "email": user.email
      }).then((_) =>
          User(user.uid, user.photoUrl, user.displayName, user.email, 0, []));
    });
  }

  Future<User> queryUserFromUid(String userUid) {
    DocumentReference doc = _db.collection(userCollection).document(userUid);
    return doc.get().then((userDoc) {
      if (userDoc.exists) {
        return User.fromMap(userDoc.data);
      } else {
        return null;
      }
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
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );
        return _auth
            .signInWithCredential(credential)
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
  static const List<dynamic> defaultIds = null;
  Future<List<MangaMetadata>> listMangas(
      {List<dynamic> ids = defaultIds}) async {
    return _db.collection(mangaCollection).getDocuments().then((query) {
      List<MangaMetadata> mangas = [];
      query.documents.forEach((doc) {
        doc.data['id'] = doc.documentID;
        if (ids != null) {
          if (ids.indexOf(doc.documentID) != -1) {
            mangas.add(MangaMetadata.fromMap(doc.data));
          }
        } else {
          mangas.add(MangaMetadata.fromMap(doc.data));
        }
      });
      var futures = <Future>[];
      mangas.forEach((manga) {
        futures.add(getComments(manga));
      });
      mangas = [];
      return Future.wait(futures).then((results) {
        results.forEach((manga) {
          mangas.add(manga);
        });
        return mangas;
      });
    });
  }

  Future<MangaMetadata> getManga(String uid) async {
    return _db.collection(mangaCollection).document(uid).get().then((doc) {
      if (!doc.exists) {
        return Future.error("missing data");
      }
      MangaMetadata manga = MangaMetadata.fromMap(doc.data);
      return getComments(manga).then((manga) => manga);
    });
  }

  Future<MangaMetadata> getChapters(MangaMetadata manga) async {
    return _db
        .collection(mangaCollection)
        .document(manga.id)
        .collection(chaptersCollection)
        .getDocuments()
        .then((query) {
      manga.chapters = query.documents.map((doc) {
        return MangaChapter.fromMap(doc.data);
      }).toList();
      return manga;
    });
  }

  Future<MangaMetadata> getComments(MangaMetadata manga) async {
    return _db
        .collection(mangaCollection)
        .document(manga.id)
        .collection(commentsCollection)
        .orderBy('score', descending: true)
        .getDocuments()
        .then((query) {
      manga.comments = query.documents.map((doc) {
        return Comment.fromMap(doc.data);
      }).toList();
      return manga;
    });
  }

  Future<void> insertManga(MangaMetadata manga) async {
    return _db
        .collection(mangaCollection)
        .document(manga.id)
        .setData(manga.toMap());
  }

  Future<void> deleteManga(String uid) async {
    return _db.collection(mangaCollection).document(uid).delete();
  }
}
