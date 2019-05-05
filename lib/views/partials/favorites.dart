import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
 final List<Widget> widgets;
 final bool display;

 Favorites(this.widgets, this.display);

 @override
 Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(10.0),
      children: widgets,
      childAspectRatio: 10/15,
      crossAxisCount: display ? 3 : 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
    );
  }
}