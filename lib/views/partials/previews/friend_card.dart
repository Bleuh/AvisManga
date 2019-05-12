import 'package:flutter/material.dart';
import 'package:avis_manga/models/user.dart';
import 'package:intl/intl.dart';
import 'package:avis_manga/views/partials/components/avatar.dart';

class FriendCard extends StatelessWidget {
  final User user;

  FriendCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Avatar(user, actif: user.lastTimeRead == null)
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              height: 70.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: user.lastTimeRead != null ? Text("Dermier manga lu ${user.lastMangaRead}") : Text("Lit actuellement ${user.lastMangaRead}")
                  ),
                  user.lastTimeRead != null ? Positioned(
                    child: Text(
                      DateFormat('dd/MM/yyyy à kk:mm').format(user.lastTimeRead),
                      style: TextStyle(fontSize: 12.0)
                    ),
                    right: 0.0,
                    bottom: 0.0,
                  ) : Container(),
                ],
              )
            ),
            flex: 5,
          )
        ],
      ),
    );
  }
}
