import 'dart:async';

import 'package:avis_manga/models/manga.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/auth.dart';

import 'package:avis_manga/views/home.dart';
import 'package:avis_manga/views/partials/loader.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => new _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();

    Auth.instance.then((Auth auth) {
      if (auth.isLogged()) {
        _loadData();
      }
      else {
        Navigator.of(context).pushReplacementNamed("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage('assets/images/bg-manga-home.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Column(
        children: <Widget>[
          Container(
            height: 150.0,
            padding: EdgeInsets.only(bottom: 20.0),
            child: Center(
              child: Loader(
                  color1: Colors.redAccent,
                  color2: Colors.green,
                  color3: Colors.amber,
                  size: 100.0
                ),
            )
          ),
          Text('Loading...', style: TextStyle(color: Colors.white))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )
    );

  }

  Future _loadData() async {
    final data = {"test": "fabulous"};
    final doc = Firestore.instance.collection("test").document();
    var response = await doc.get();
    if (response.data == null || response.data["test"] != data["test"]) {
      await doc.setData(data);
    }
    response = await doc.get();
    new Timer(new Duration(seconds: 2), () {
      // TODO: only for testing
      _dataLoaded(data: {
        'test': new MangaMetadata(
            title: "Test Manga",
            description:
                "a manga for testing. this is a very long description and i don't what to say but this is for testing purpose. bajlkjadlkjasjdksldjlakjsdjldakjkjl",
            mainImage: "https://cdn.japscan.cc/lel/Radiant/1/05.jpg",
            nbChap: 10,
            rating: 3.5,
            tags: ["Comedy", "Action", "Slice of life"]),
      });
    });
  }

  void _dataLoaded({data}) {
    Navigator.of(context).push(new MaterialPageRoute(
      settings: const RouteSettings(name: '/home'),
      builder: (context) => new HomePage(data: data),
    ));
  }
}
