import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:avis_manga/models/user.dart';
import 'package:avis_manga/auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:avis_manga/data/upload.dart';
import 'package:avis_manga/data/db.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, @required this.user}) : super(key: key);

  final String title = 'Editer son profil';
  User user;

  @override
  _EditPageState createState() => new _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final saveFormKey = new GlobalKey<FormState>();
  final codeFormKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final _emailController = new TextEditingController();
  final _nameController = new TextEditingController();
  final _codeController = new TextEditingController();
  ImageProvider imageProvider;
  String imagePath = '';

  @override
  void initState() {
    _emailController.text = widget.user.email;
    _nameController.text = widget.user.name;
    imageProvider = CachedNetworkImageProvider(widget.user.avatar);
    super.initState();
  }

  Widget buildTextRow(String text) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: new Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImageRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: new Container(
        height: 150.0,
        width: 150.0,
        child: new FloatingActionButton(
          onPressed: () {
            FilePicker.getFilePath(type: FileType.CUSTOM, fileExtension: 'png').then((path) => {
              setState(() {
                imageProvider = AssetImage(path);
                imagePath = path;
              }),
            });
          },
          child: Stack(
            children: <Widget>[
              ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: ClipOval(
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: FlatButton(
                  padding: EdgeInsets.all(10.0),
                  shape: CircleBorder(),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    FilePicker.getFilePath(type: FileType.CUSTOM, fileExtension: 'png').then((path) => {
                      setState(() {
                        imageProvider = AssetImage(path);
                        imagePath = path;
                      }),
                    });
                  },
                  child: Icon(Icons.edit, size: 25.0, color: Colors.white)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailInput() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 0.5,
              style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: _emailController,
              validator: (val) {
                return val.length < 10
                    ? "Email must have atleast 10 chars"
                    : null;
              },
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'avismanga@gmail.com',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNameInput() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 0.5,
              style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: _nameController,
              validator: (val) {
                return val.length < 2
                    ? "Username must have atleast 2 chars"
                    : null;
              },
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Avis Manga',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConfirmButton(String text, VoidCallback onPressed, {double top: 0.0}) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: top),
      alignment: Alignment.center,
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: onPressed,
              child: new Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: Text(
                        text,
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
    );
  }

  Widget buildSold() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 0.0),
      alignment: Alignment.center,
      child: Form(
        key: codeFormKey,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text("${widget.user.wallet} ¥")
              ),
            ),
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
                  validator: (val) {
                    if (val.length < 4) {
                      return "Code must have atleast 4 chars";
                    } else if(val != "welcome") {
                      return "Code not find";
                    } else {
                      return null;
                    }
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Code',
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
                    widget.user.wallet += 20;
                    Auth.instance.then((auth) => auth.setUser(widget.user));
                    Database.instance.updateUser(widget.user).then((_) {
                      _showSnackBar('20 ¥ ajouter sur votre compte !');
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
                          'Valider',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        child: Form(
          key: saveFormKey,
          child: ListView(
            children: <Widget>[
              Container(
                height: 24.0,
              ),
              buildSold(),
              Container(
                height: 24.0,
              ),
              buildTextRow('Avatar'),
              buildImageRow(),
              Container(
                height: 24.0,
              ),
              buildTextRow('Nom'),
              buildNameInput(),
              Container(
                height: 24.0,
              ),
              buildTextRow('Email'),
              buildEmailInput(),
              Container(
                height: 24.0,
              ),
              buildConfirmButton("Mettre à jour", () {
                if (saveFormKey.currentState.validate()) {
                  widget.user.email = _emailController.text;
                  widget.user.name = _nameController.text;
                  if (imagePath.isNotEmpty) {
                    _showSnackBar('Upload en cours...');
                    Upload.removeProfilePicture(widget.user.avatar);
                    Upload.uploadProfilePicture(imagePath).then((url) {
                      widget.user.avatar = url;
                      Auth.instance.then((auth) => auth.setUser(widget.user));
                      Database.instance.updateUser(widget.user).then((_) {
                        _showSnackBar('Profil mis à jour !');
                          setState(() {
                            imagePath = '';
                          });
                      });
                    });
                  }
                  else {
                    Auth.instance.then((auth) => auth.setUser(widget.user));
                    Database.instance.updateUser(widget.user).then((_) {
                      _showSnackBar('Profil mis à jour !');
                    });
                  }
                }
              }, top: 0.0),
              Container(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

}