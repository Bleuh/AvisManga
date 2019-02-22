import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
 final widgets;

 Favorites(this.widgets);

 @override
 Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgets,
      ),
    );
  }
}