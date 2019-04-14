import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/auth.dart';

class HomeDrawer extends StatelessWidget {
  final User user;
  HomeDrawer(this.user);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(user.name != null ? user.name : 'Anonymous'),
                accountEmail: new Text((user.wallet != null ? user.wallet.toString() : '0') + ' ¥'),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: new CachedNetworkImageProvider(user.avatar),
                ),
                otherAccountsPictures: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/edit');
                    },
                    color: Colors.white,
                  )
                ],
              ),
              new ListTile(
                title: new Text('data'),
              ),
              new Divider(),
              new ListTile(
                title: new Text('data'),
              ),
            ],
          ),
          Positioned(
            child: Container(
              child: new ListTile(
                title: new Text('Logout from AvisManga', style: TextStyle(color: Colors.white)),
                onTap: () => Auth.instance.then((a) => a.doLogout()),
                trailing:  Icon(Icons.exit_to_app, color: Colors.white,),
                contentPadding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 20.0, right: 20.0),
              ),
              decoration:  new BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            bottom: 0,
            width: 305,
          )
        ],
      ),
    );
  }
}
