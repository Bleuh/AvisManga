import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
 final widgets;

 Feed(this.widgets);

 @override
 Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: widgets,
      ),
    );
  }
}