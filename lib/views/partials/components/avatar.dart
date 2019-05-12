import 'package:flutter/material.dart';
import 'package:avis_manga/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Avatar extends StatelessWidget {
  final User user;
  final Color textColor;
  final bool actif;

  Avatar(this.user, {this.textColor, this.actif = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: Column(
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            child: Stack(
              children: <Widget>[
                ConstrainedBox(
                  constraints: new BoxConstraints.expand(),
                  child: ClipOval(
                    child: Image(
                      image: CachedNetworkImageProvider(user.avatar),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                actif ? Positioned(
                  right: 2.0,
                  bottom: 2.0,
                  child: Container(
                    height: 15.0,
                    width: 15.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                    ),
                  ),
                ) : Container(),
              ],
            ),
          ),
          Text(user.name, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}