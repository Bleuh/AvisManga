import 'package:flutter/material.dart';
import 'package:avis_manga/models/comment.dart';
import 'package:avis_manga/views/partials/components/avatar.dart';
import 'package:avis_manga/views/partials/components/score.dart';

class CommentRow extends StatelessWidget {
  final Comment comment;

  CommentRow(this.comment);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Score(comment.score)
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Avatar(comment.user)
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              child: Text(comment.content)
            ),
            flex: 5,
          )
        ],
      )
    );
  }
}