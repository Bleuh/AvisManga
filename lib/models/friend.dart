class Friend {
  String uid;
  DateTime createAt;
  bool accepted;
  bool sender;

  Friend(
      {this.uid,
      this.createAt,
      this.accepted,
      this.sender});

  Friend.fromMap(Map<String, dynamic> data) {
    this.uid = data["uid"];
    this.createAt = data["create_at"].toDate();
    this.accepted = data["accepted"];
    this.sender = data["sender"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = new Map();
    result["uid"] = this.uid;
    result["create_at"] = this.createAt;
    result["accepted"] = this.accepted;
    result["sender"] = this.sender;
    return result;
  }
}
