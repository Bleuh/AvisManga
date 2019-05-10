import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  final int score;
  final Color textColor;

  Score(this.score, {this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(Icons.arrow_drop_up, size: 30.0, color: textColor,),
          Text(score.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, color: textColor),),
          Icon(Icons.arrow_drop_down, size: 30.0, color: textColor),
        ],
      ),
    );
  }
}