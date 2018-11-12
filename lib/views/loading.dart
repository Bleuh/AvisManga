import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

import 'package:avis_manga/models/manga.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:avis_manga/auth.dart';

import 'package:avis_manga/views/login.dart';
import 'package:avis_manga/views/home.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => new _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  bool _loadingInProgress;

  Animation<double> _angleAnimation;
  Animation<double> _scaleAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadingInProgress = true;

    _controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _angleAnimation = new Tween(begin: 0.0, end: 360.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    _scaleAnimation = new Tween(begin: 1.0, end: 6.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _angleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_loadingInProgress) {
          _controller.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        if (_loadingInProgress) {
          _controller.forward();
        }
      }
    });

    _controller.forward();

    Auth.instance.then((Auth auth) {
      if (auth.isLogged()) {
        _loadData();
      }
      else {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          settings: const RouteSettings(name: '/login'),
          builder: (context) => new LoginPage(),
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Container(
          height: 150.0,
          padding: EdgeInsets.only(bottom: 20.0),
          child: Center(child: _buildAnimation()),
        ),
        Text('Loading', style: TextStyle(color: Colors.white))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _buildAnimation() {
    double circleWidth = 10.0 * _scaleAnimation.value;
    Widget circles = new Container(
      width: circleWidth * 2.0,
      height: circleWidth * 2.0,
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              _buildCircle(circleWidth, Colors.blue),
              _buildCircle(circleWidth, Colors.red),
            ],
          ),
          new Row(
            children: <Widget>[
              _buildCircle(circleWidth, Colors.yellow),
              _buildCircle(circleWidth, Colors.green),
            ],
          ),
        ],
      ),
    );

    double angleInDegrees = _angleAnimation.value;
    return new Transform.rotate(
      angle: angleInDegrees / 360 * 2 * pi,
      child: new Container(
        child: circles,
      ),
    );
  }

  Widget _buildCircle(double circleWidth, Color color) {
    return new Container(
      width: circleWidth,
      height: circleWidth,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
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
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      settings: const RouteSettings(name: '/home'),
      builder: (context) => new HomePage(data: data),
    ));
  }
}
