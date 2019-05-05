import 'package:avis_manga/models/user.dart';

class Comment {
  String uid;
  String content;
  DateTime publishDate;
  User user;
  int score;

  Comment(
    this.uid,
    this.content,
    this.publishDate,
    this.user,
    this.score
  );

  Comment.fromMap(Map<String, dynamic> m) {
    this.uid = m["uid"];
    this.content = m["content"];
    this.publishDate = m["publish_date"].toDate();
    this.user = User.fromMap(Map<String, dynamic>.from(m['user']));
    this.score = m["score"];
  }
}