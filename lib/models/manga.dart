import 'package:avis_manga/models/comment.dart';
import 'package:avis_manga/models/author.dart';

enum MangaStatus {
  Dropped,
  Pending,
  Airing,
  Complete,
}

class MangaChapter {
  String key;
  int number;

  MangaChapter.fromMap(Map<String, dynamic> data) {
    this.key = data["key"];
    this.number = data["number"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = new Map();
    result["key"] = this.key;
    result["number"] = this.number;
    return result;
  }
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
  Author author;
  List<MangaChapter> chapters;
  List images;
  List<Comment> comments;

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
      this.chapters,
      this.images,
      this.comments});

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
    this.author = Author.fromMap(new Map<String, dynamic>.from(data["author"]));
    this.chapters = [];
    this.images = data["images"];
    this.comments = [];
  }

  String statusString() {
    switch (this.status) {
      case MangaStatus.Airing:
        return 'En cours';
        break;
      case MangaStatus.Complete:
        return 'Terminé';
        break;
      case MangaStatus.Dropped:
        return 'Abandonné';
        break;
      case MangaStatus.Pending:
        return 'En cours';
        break;
      default:
        return 'Pas d\'informatique';
    }
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
    result["images"] = this.images;
    return result;
  }
}
