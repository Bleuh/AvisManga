import 'package:flutter/material.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/auth.dart';
import 'package:intl/intl.dart';
import 'package:avis_manga/views/partials/components/avatar.dart';

class FriendCardPending extends StatelessWidget {
  final User user;
  final bool sender;

  FriendCardPending(this.user, {this.sender = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Avatar(user)
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              height: 70.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        !sender ? Text("Soutaite devenir votre ami") : Text("Demande d'amis en attente"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            !sender ? Container(
                              margin: EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: (){
                                  Auth.instance.then((auth){
                                    user.friends.firstWhere((f) => f.uid == auth.currentUser.uid).accepted = true;
                                    auth.currentUser.friends.firstWhere((f) => f.uid == user.uid).accepted = true;
                                    Future.wait(<Future>[Auth.db.updateUser(user), Auth.db.updateUser(auth.currentUser)]);
                                  });
                                },
                                child: Icon(Icons.group_add, color:Colors.green, size: 30.0)
                              ),
                            ) : Container(),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: (){
                                  Auth.instance.then((auth){
                                    user.friends.removeWhere((f) => f.uid == auth.currentUser.uid);
                                    auth.currentUser.friends.removeWhere((f) => f.uid == user.uid);
                                    Future.wait(<Future>[Auth.db.updateUser(user), Auth.db.updateUser(auth.currentUser)]);
                                  });
                                },
                                child: Icon(Icons.not_interested, color:Colors.red, size: 30.0)
                              )
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                  Positioned(
                    child: Text(
                      DateFormat('dd/MM/yyyy à kk:mm').format(user.lastTimeRead),
                      style: TextStyle(fontSize: 12.0)
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
      ),
    );
  }
}
