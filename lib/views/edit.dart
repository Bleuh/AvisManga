import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key}) : super(key: key);

  final String title = 'AvisManga';

  @override
  _EditPageState createState() => new _EditPageState();
}

class _EditPageState extends State<EditPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
    );
  }

}