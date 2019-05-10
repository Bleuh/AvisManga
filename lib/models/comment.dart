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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = new Map();
    result["content"] = this.content;
    result["publish_date"] = this.publishDate;
    result["user"] = new Map.from({
      'avatar': this.user.avatar,
      'name': this.user.name,
      'uid': this.user.uid
    });
    result["score"] = this.score;
    return result;
  }
}