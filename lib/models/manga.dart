enum MangaStatus {
  Dropped,
  Pending,
  Airing,
  Complete,
}

class MangaMetadata {
  String id;
  String title;
  String description;
  String mainImage;
  String coverImage;
  int nbChap;
  double rating;
  MangaStatus status;
  List tags;
  Map author;
  List<dynamic> chapters;

  MangaMetadata(
      {this.id,
      this.title,
      this.description,
      this.mainImage,
      this.coverImage,
      this.nbChap,
      this.rating,
      this.status,
      this.tags,
      this.author,
      this.chapters});

  MangaMetadata.fromMap(Map<String, dynamic> data) {
    this.id = data["id"];
    this.title = data["title"];
    this.description = data["description"];
    this.mainImage = data["main_image"];
    this.coverImage = data["cover_image"];
    this.nbChap = data["nb_chap"];
    this.rating = data["rating"];
    this.status = MangaStatus.values[data["status"]];
    this.tags = data["tags"];
    this.author = data["author"];
    this.chapters = [];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = new Map();
    result["id"] = this.id;
    result["title"] = this.title;
    result["description"] = this.description;
    result["main_image"] = this.mainImage;
    result["cover_image"] = this.coverImage;
    result["nb_chap"] = this.nbChap;
    result["status"] = this.status.index;
    result["tags"] = this.tags;
    result["author"] = this.author;
    return result;
  }
}
