class User {
  String uid;

  User(this.uid);

  User.fromMap(Map<String, dynamic> m) {
    this.uid = m["uid"];
  }
}