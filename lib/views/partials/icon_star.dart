import 'package:flutter/material.dart';

class IconStar extends StatelessWidget {
  final Color color;
  final double rating;
  final int index;

  IconStar({this.color, this.rating, this.index});

  @override
    Widget build(BuildContext context) {
      IconData data;
      if (index >= rating) {
        data = Icons.star_border;
      } else if (index < rating && index > (rating - 1)) {
        data = Icons.star_half;
      } else {
        data = Icons.star;
      }
      return Icon(data, color: color);
    }
}