import 'package:flutter/material.dart';

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

  MangaMetadata({this.title, this.description, this.mainImage, this.nbChap, this.rating, this.status, this.tags});
}