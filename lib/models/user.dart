class User {
  String uid;
  String avatar;
  String name;
  String email;
  int wallet;

  User(
    this.uid,
    this.avatar,
    this.name,
    this.email,
    this.wallet
  );

  User.fromMap(Map<String, dynamic> m) {
    this.uid = m["uid"];
    this.avatar = m["avatar"];
    this.name = m["name"];
    this.email = m["email"];
    this.wallet = m["wallet"];
  }
}