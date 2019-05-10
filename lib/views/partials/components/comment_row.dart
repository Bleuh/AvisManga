import 'package:flutter/material.dart';
import 'package:avis_manga/models/comment.dart';
import 'package:avis_manga/views/partials/components/avatar.dart';
import 'package:avis_manga/views/partials/components/score.dart';
import 'package:intl/intl.dart';

class CommentRow extends StatelessWidget {
  final Comment comment;
  final Color textColor;

  CommentRow(this.comment, {this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Score(comment.score, textColor: textColor)
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Avatar(comment.user, textColor: textColor)
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              height: 70.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(comment.content, style: TextStyle(color: textColor))
                  ),
                  Positioned(
                    child: Text(
                      DateFormat('dd/MM/yyyy à kk:mm').format(comment.publishDate),
                      style: TextStyle(color: textColor, fontSize: 12.0)
                    ),
                    right: 0.0,
                    bottom: 0.0,
                  ),
                ],
              )
            ),
            flex: 5,
          )
        ],
      )
    );
  }
}