import 'package:flutter/material.dart';
import 'package:avis_manga/models/friend.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/auth.dart';
import 'package:avis_manga/views/partials/previews/friend_card.dart';
import 'package:avis_manga/views/partials/previews/friend_card_pending.dart';

class FriendsList extends StatelessWidget {
  final List<Friend> friends;
  final codeFormKey = new GlobalKey<FormState>();
  final _codeController = new TextEditingController();

  FriendsList(this.friends);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
       Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
          alignment: Alignment.center,
          child: Form(
            key: codeFormKey,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 0.5,
                          style: BorderStyle.solid
                        ),
                      ),
                    ),
                    child: TextFormField(
                      controller: _codeController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nom d'utilisateur",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (codeFormKey.currentState.validate()) {
                        var userName = _codeController.text;
                        Database.instance.queryUserFromName(userName).then((user){
                          if (user != null) {
                            Auth.instance.then((auth){
                              user.friends.add(new Friend(uid: auth.currentUser.uid, createAt: DateTime.now(),accepted: false, sender: false));
                              auth.currentUser.friends.add(new Friend(uid: user.uid, createAt: DateTime.now(),accepted: false, sender: true));
                              Future.wait(<Future>[Auth.db.updateUser(user), Auth.db.updateUser(auth.currentUser)]);
                            });
                          } else {

                          }
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Ajouter',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        friends.where((f) => !f.accepted).isNotEmpty ?
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 15.0),
          alignment: Alignment.centerLeft,
          child: Text(
            "En attente",
            style: Theme.of(context).textTheme.title,
          ),
        ) : Container(),
        friends.where((f) => !f.accepted).isNotEmpty ?
        Container(
          child: Column(
            children: List.generate(friends.where((f) => !f.accepted).length, (int index) {
              return Container(
                margin: EdgeInsets.all(10.0),
                height: 100.0,
                child: FutureBuilder(
                  future: Database.instance.queryUserFromUid(friends.where((f) => !f.accepted).toList()[index].uid),
                  builder: (context, snapshot){
                    if (snapshot.hasData) {
                      return FriendCardPending(snapshot.data, sender: friends.where((f) => !f.accepted).toList()[index].sender);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ) : Container(),
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 15.0),
          alignment: Alignment.centerLeft,
          child: Text(
            "Amis",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Container(
          child: Column(
            children: List.generate(friends.where((f) => f.accepted).length, (int index) {
              return Container(
                margin: EdgeInsets.all(10.0),
                height: 100.0,
                child: FutureBuilder(
                  future: Database.instance.queryUserFromUid(friends.where((f) => f.accepted).toList()[index].uid),
                  builder: (context, snapshot){
                    if (snapshot.hasData) {
                      return FriendCard(snapshot.data);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        )
        // Container(
        //   child: ListView.builder(
        //     itemCount: friends.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return Container(
        //         margin: EdgeInsets.all(10.0),
        //         height: 100.0,
        //         child: FutureBuilder(
        //           future: Database.instance.queryUserFromUid(friends[index].uid),
        //           builder: (context, snapshot){
        //             if (snapshot.hasData) {
        //               return FriendCard(snapshot.data);
        //             } else {
        //               return Center(
        //                 child: CircularProgressIndicator(),
        //               );
        //             }
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}