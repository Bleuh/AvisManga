class Author {
  String biography;
  DateTime birthDay;
  String birthPlace;
  String firstName;
  String lastName;
  String image;

  Author(
      {this.biography,
      this.birthDay,
      this.birthPlace,
      this.firstName,
      this.lastName,
      this.image});

  Author.fromMap(Map<String, dynamic> data) {
    this.biography = data["biography"];
    this.birthDay = data["birth_day"].toDate();
    this.birthPlace = data["birth_place"];
    this.firstName = data["first_name"];
    this.lastName = data["last_name"];
    this.image = data["image"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = new Map();
    result["biography"] = this.biography;
    result["birth_day"] = this.birthDay;
    result["birth_place"] = this.birthPlace;
    result["first_name"] = this.firstName;
    result["last_name"] = this.lastName;
    result["image"] = this.image;
    return result;
  }
}
