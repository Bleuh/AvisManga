import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  final int score;

  Score(this.score);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(Icons.arrow_drop_up, size: 30.0),
          Text(score.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0),),
          Icon(Icons.arrow_drop_down, size: 30.0),
        ],
      ),
    );
  }
}