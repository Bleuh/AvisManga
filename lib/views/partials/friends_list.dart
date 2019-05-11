import 'package:flutter/material.dart';
import 'package:avis_manga/models/friend.dart';
import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/views/partials/previews/friend_card.dart';

class FriendsList extends StatelessWidget {
  final List<Friend> friends;

  FriendsList(this.friends);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.all(10.0),
          height: 100.0,
          child: FutureBuilder(
            future: Database.instance.queryUserFromUid(friends[index].uid),
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
      },
    );
  }
}