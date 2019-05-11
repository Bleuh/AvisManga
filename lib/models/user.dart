import 'package:avis_manga/models/friend.dart';
import 'package:avis_manga/models/comment.dart';

class User {
  String uid;
  String avatar;
  String name;
  String email;
  int wallet;
  List<dynamic> favorites;
  List<dynamic> ownManga;
  List<Friend> friends;
  List<Comment> comments;
  String lastMangaRead;
  DateTime lastTimeRead;

  User(
    this.uid,
    this.avatar,
    this.name,
    this.email,
    this.wallet,
    this.favorites,
    this.ownManga,
    this.friends,
    this.comments,
    this.lastMangaRead,
    this.lastTimeRead
  );

  User.fromMap(Map<String, dynamic> m) {
    this.uid = m["uid"];
    this.avatar = m["avatar"];
    this.name = m["name"];
    this.email = m["email"];
    this.wallet = m["wallet"];
    this.favorites = m["favorites"];
    this.ownManga = m["own_manga"];
    List<dynamic> friends = m["friends"];
    this.friends = friends != null && friends.isNotEmpty ? friends.map((f) => Friend.fromMap(Map<String, dynamic>.from(f))).toList() : new List();
    List<dynamic> comments = m["comments"];
    this.comments = comments != null && comments.isNotEmpty ? comments.map((f) => Comment.fromMap(Map<String, dynamic>.from(f))).toList() : new List();
    this.lastMangaRead = m["last_manga_read"];
    this.lastTimeRead = m["last_time_read"] != null ? m["last_time_read"].toDate() : null;
  }
}