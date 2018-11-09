enum MangaStatus {
  Dropped,
  Pending,
  Airing,
  Complete,
}

class MangaMetadata {
  String title;
  String description;
  String mainImage;
  int nbChap;
  double rating;
  MangaStatus status;
  List<String> tags;

  MangaMetadata(
      {this.title,
      this.description,
      this.mainImage,
      this.nbChap,
      this.rating,
      this.status,
      this.tags});

  MangaMetadata.fromMap(Map<String, dynamic> data) {
    this.title = data["title"];
    this.description = data["description"];
    this.mainImage = data["main_image"];
    this.nbChap = data["nb_chap"];
    this.rating = data["rating"];
    this.status = MangaStatus.values[data["status"]];
    this.tags = data["tags"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = new Map();
    result["title"] = this.title;
    result["description"] = this.description;
    result["main_image"] = this.mainImage;
    result["nb_chap"] = this.nbChap;
    result["status"] = this.status.index;
    result["tags"] = this.tags;
    return result;
  }
}
