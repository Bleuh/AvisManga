import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/auth.dart';
import 'package:avis_manga/views/edit.dart';

class HomeDrawer extends StatelessWidget {
  final User user;
  HomeDrawer(this.user);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
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
                        Navigator.push(context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) => new EditPage(user: this.user)
                          )
                        );
                      },
                      color: Colors.white,
                    )
                  ],
                ),
                Container(
                  height:  MediaQuery.of(context).size.height - 249.0,
                  padding: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA)
                  ),
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text('Configuration', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      Divider(color: Theme.of(context).primaryColorLight, indent: 4.0),
                      ListTile(
                        title: new Text('Modifier mon compte'),
                        onTap: () {
                          Navigator.push(context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => new EditPage(user: this.user)
                            )
                          );
                        }
                      ),
                      ListTile(
                        title: new Text('Changer de langage'),
                      ),
                      ListTile(
                        title: new Text('Customiser mon thème'),
                      ),
                      ListTile(
                        title: new Text('Assitance', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      Divider(color: Theme.of(context).primaryColorLight, indent: 4.0),
                      ListTile(
                        title: new Text('Nous contacter'),
                      ),
                      ListTile(
                        title: new Text('Recherche de mise à jour'),
                      ),
                      ListTile(
                        title: new Text('A propos'),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              child: Container(
                child: new ListTile(
                  title: new Text('Se deconnecter d\'AvisManga', style: TextStyle(color: Colors.white)),
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
      ),
    );
  }
}
