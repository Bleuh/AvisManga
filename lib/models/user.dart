class User {
  String uid;
  String avatar;
  String name;
  String email;
  int wallet;
  List<dynamic> favorites;

  User(
    this.uid,
    this.avatar,
    this.name,
    this.email,
    this.wallet,
    this.favorites
  );

  User.fromMap(Map<String, dynamic> m) {
    this.uid = m["uid"];
    this.avatar = m["avatar"];
    this.name = m["name"];
    this.email = m["email"];
    this.wallet = m["wallet"];
    this.favorites = m["favorites"];
  }
}