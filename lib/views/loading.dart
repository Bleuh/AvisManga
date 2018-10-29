import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../data/firebase.dart';
import 'home.dart';


class LoadingPage extends StatefulWidget {
  LoadingPage({Key key, this.bgColor}) : super(key: key);

  final Color bgColor;

  @override
  _LoadingPageState createState() => new _LoadingPageState();

}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {

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

    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: const Color(0xFFFF0000))
          ),
          _buildAnimation()
        ] ,
      );
    } else {
      return new Center (
        child: new Text('Data loaded'),
      );
    }
  }

  Widget _buildAnimation() {
    double circleWidth = 10.0 * _scaleAnimation.value;
    Widget circles = new Container(
      width: circleWidth * 2.0,
      height: circleWidth * 2.0,
      child: new Column(
        children: <Widget>[
          new Row (
              children: <Widget>[
                _buildCircle(circleWidth,Colors.blue),
                _buildCircle(circleWidth,Colors.red),
              ],
          ),
          new Row (
            children: <Widget>[
              _buildCircle(circleWidth,Colors.yellow),
              _buildCircle(circleWidth,Colors.green),
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
    final response = await new Firebase().call();
    _dataLoaded('test');
  }

  void _dataLoaded(response) {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        settings: const RouteSettings(name: '/home'),
        builder: (context) => new HomePage(response: response),
      )
    );
  }
}